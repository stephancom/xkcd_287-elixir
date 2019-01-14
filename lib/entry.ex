defmodule Entry do
  @moduledoc """
  Defines a struct for an entry in an order, including an item and a quantity
  """

  @type t :: %__MODULE__{
    item: Item,
    quantity: integer
  }

  defstruct item: Item, quantity: 1

  @type order() :: [t, ...]

  @spec new(Item.t, pos_integer) :: t
  @doc ~S"""
  Create a new `Entry` struct with an Item and quantity

  ## Examples

    iex> Entry.new(Item.parse("caviar,$99.99"), 2)
    %Entry{item: %Item{name: "caviar", price: %Money{amount: 9999, currency: :USD}}, quantity: 2}

  """ 
  def new(item, quantity) when quantity > 0,
    do: %Entry{item: item, quantity: quantity}

  @spec subtotal(t) :: Money.t
  @doc ~S"""
  Returns total for this item and quantity

  ## Examples

    iex> Entry.subtotal(Entry.new(Item.parse("caviar,$99.99"), 2))
    %Money{amount: 19998, currency: :USD}
  """
  def subtotal(%Entry{item: %Item{name: _, price: price}, quantity: quantity}),
    do: Money.multiply(price, quantity)

  @spec total(order()) :: Money.t
  @doc ~S"""
  Returns the total of a list of entries

  ## Examples

    iex> Entry.total([
    ...> Entry.new(Item.parse("tuna sandwich,$3.50"), 2),
    ...> Entry.new(Item.parse("caesar salad,$5.25"), 1),
    ...> Entry.new(Item.parse("onion rings,$2.00"), 1),
    ...> Entry.new(Item.parse("fountain drink,$1.00"), 3)
    ...> ])
    %Money{amount: 1725, currency: :USD}
  """
  def total(entries) do
    Enum.map(entries, &subtotal/1) |> Enum.reduce(&Money.add/2)
  end

  @spec print(order()) :: :ok
  @doc ~S"""
  Prints a list of entries
  """
  def print(entries) do
    Scribe.print(entries, data: [{"Quantity", :quantity}, 
                                 {"Item", fn(e) -> e.item.name end},
                                 {"Cost", fn(e) -> Money.to_string(Entry.subtotal(e)) end}])
  end
end