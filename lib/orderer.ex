defmodule Orderer do
  @moduledoc """
  Generates orders of an exact target amount
  """

  @type menu() :: [Item.t, ...]
  @type order() :: [Entry.t, ...]

  @spec generate({menu(), Money.t}) :: [order()]
  @doc ~S"""
  Wrapper around generation routine to assure that items are sorted
  """
  def generate({menu, total}) do
    suborders(Item.sort(menu), total)
  end

  @spec trivial_orders(Item.t, Money.t) :: [order()]
  @doc ~S"""
  Returns an array of an order containing a multiple of a single item with the desired total if one exists
  or an empty array if none exist.  Uses integer div/rem.  Only ever returns one, but we're calling it plural
  since it returns an array.

  ## Examples

    iex> Orderer.trivial_orders(Item.parse("Борщ,$1.23"),Money.parse!("$7.38"))
    [[%Entry{item: %Item{name: "Борщ", price: %Money{amount: 123, currency: :USD}},quantity: 6}]]

    iex> Orderer.trivial_orders(Item.parse("Борщ,$1.23"),Money.parse!("$7.00"))
    []

  """
  def trivial_orders(%Item{price: %Money{amount: price}} = item, %Money{amount: amount} = total) when amount > 0 and rem(amount, price)==0 do
    [[Entry.new(item, div(total.amount, item.price.amount))]]
  end
  def trivial_orders(_item, _total) do
    []
  end

  @spec add_base_order([order()], Item.t, integer) :: [order()]
  @doc ~S"""
  Append a single item to each order if the quantity is positive

  ## Examples

    iex> Orderer.add_base_order([
    ...> [%Entry{item: %Item{name: "avocado", price: %Money{amount: 100, currency: :USD}}, quantity: 1}, %Entry{item: %Item{name: "bacon", price: %Money{amount: 200, currency: :USD}}, quantity: 2}],
    ...> [%Entry{item: %Item{name: "cheddar", price: %Money{amount: 300, currency: :USD}}, quantity: 3}]],
    ...> %Item{name: "doritos", price: %Money{amount: 400, currency: :USD}}, 4)
    [[%Entry{item: %Item{name: "avocado", price: %Money{amount: 100, currency: :USD}}, quantity: 1},
      %Entry{item: %Item{name: "bacon", price: %Money{amount: 200, currency: :USD}}, quantity: 2},
      %Entry{item: %Item{name: "doritos", price: %Money{amount: 400, currency: :USD}}, quantity: 4}],
     [%Entry{item: %Item{name: "cheddar", price: %Money{amount: 300, currency: :USD}}, quantity: 3},
      %Entry{item: %Item{name: "doritos", price: %Money{amount: 400, currency: :USD}}, quantity: 4}]]

    iex> Orderer.add_base_order([
    ...> [%Entry{item: %Item{name: "avocado", price: %Money{amount: 100, currency: :USD}}, quantity: 1}, %Entry{item: %Item{name: "bacon", price: %Money{amount: 200, currency: :USD}}, quantity: 2}],
    ...> [%Entry{item: %Item{name: "cheddar", price: %Money{amount: 300, currency: :USD}}, quantity: 3}]],
    ...> %Item{name: "doritos", price: %Money{amount: 400, currency: :USD}}, 0)
    [[%Entry{item: %Item{name: "avocado", price: %Money{amount: 100, currency: :USD}}, quantity: 1},
      %Entry{item: %Item{name: "bacon", price: %Money{amount: 200, currency: :USD}}, quantity: 2}],
     [%Entry{item: %Item{name: "cheddar", price: %Money{amount: 300, currency: :USD}}, quantity: 3}]]

  """
  def add_base_order(orders, item, quantity) when quantity > 0 do
    Enum.map(orders, fn order -> order ++ [Entry.new(item, quantity)] end)
  end
  def add_base_order(orders, _, _) do
    orders
  end

  @spec suborders(menu(), Money.t) :: [order()]
  @doc ~S"""
  Return a list of orders with the given total.  Expects menu to be sorted with most expensive items first.

    iex> Orderer.suborders(Item.parse(["Cheezborger,$3.15","Hamborger,$2.95","Pepsi,$1.65","Chips,$1.00"]), Money.parse!("$5.80"))
    [[%Entry{item: %Item{name: "Chips", price: %Money{amount: 100, currency: :USD}}, quantity: 1},
      %Entry{item: %Item{name: "Pepsi", price: %Money{amount: 165, currency: :USD}}, quantity: 1},
      %Entry{item: %Item{name: "Cheezborger", price: %Money{amount: 315, currency: :USD}}, quantity: 1}]]
  """
  def suborders(menu, %Money{amount: amount}) when length(menu) == 0 or amount <= 0 do
    []
  end
  def suborders(menu, total) do
    [item | items] = menu
    Enum.reduce(0..div(total.amount, item.price.amount), trivial_orders(item, total),
                fn quantity, results ->
                  subtotal = Money.subtract(total, Money.multiply(item.price, quantity))
                  results ++ (Orderer.suborders(items, subtotal) |> add_base_order(item, quantity))
                end)
  end  
end
