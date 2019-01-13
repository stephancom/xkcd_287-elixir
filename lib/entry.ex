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
    %Entry{item: %Item{name: "caviar", price: %Money{amount: 999900, currency: :USD}}, quantity: 2}

  """ 
  def new(item, quantity) when quantity > 0,
    do: %Entry{item: item, quantity: quantity}

  @spec subtotal(t) :: Money.t
  @doc ~S"""
  Returns total for this item and quantity

  ## Examples

    iex> Entry.subtotal(Entry.new(Item.parse("caviar,$99.99"), 2))
    %Money{amount: 1999800, currency: :USD}
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
    %Money{amount: 172500, currency: :USD}
  """
  def total(entries) do
    Enum.reduce(entries, Money.new(0), fn(entry, total) -> Money.add(total, Entry.subtotal(entry)) end)
  end
end