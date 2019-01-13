defmodule Item do
  @moduledoc """
  Defines a struct for a menu item with a name and price
  """

  @type t :: %__MODULE__{
    name: String.t,
    price: Money.t
  }

  defstruct name: "food item", price: Money.new(1)

  @type menu() :: [t, ...]

  @spec new(String.t, Money.t) :: t
  @doc ~S"""
  Create a new `Item` struct with a name and price

  ## Examples

    iex> Item.new("grilled cheese", Money.parse!("$1.25"))
    %Item{name: "grilled cheese", price: %Money{amount: 12500, currency: :USD}}

  """
  def new(name, %Money{amount: amount} = price) when amount > 0,
    do: %Item{name: name, price: price}

  @spec parse(String.t) :: {:ok, t}
  @doc ~S"""
  Parse a comma-separated string into name and price

  ## Examples

    iex> Item.parse("cheezborger,$2.50")
    %Item{name: "cheezborger", price: %Money{amount: 25000, currency: :USD}}

    iex> Item.parse("caviar,$99.99")
    %Item{name: "caviar", price: %Money{amount: 999900, currency: :USD}}

  """
  def parse(string) when is_binary(string) do
    [name | price] = String.split(string, ",", parts: 2)
    new(name, Money.parse!(hd(price)))
  end

  @spec parse([String.t]) :: menu()
  @doc ~S"""
  Parse a list of comma-separated strings into parsed menu items

  ## Examples

    iex> Item.parse(["coffee,$2.00","tea,$1.00","me,$9.99"])
    [%Item{name: "coffee", price: %Money{amount: 20000, currency: :USD}},
     %Item{name: "tea", price: %Money{amount: 10000, currency: :USD}},
     %Item{name: "me", price: %Money{amount: 99900, currency: :USD}}]
  """
  def parse(menu_rows) when is_list(menu_rows) do
    Enum.map(menu_rows, fn r -> Item.parse(r) end)
  end
end