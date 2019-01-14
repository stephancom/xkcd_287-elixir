#     by_stephan.com_     ____  ___ _____ 
# __  _| | _____ __| |   |___ \( _ )___  |
# \ \/ / |/ / __/ _` |     __) / _ \  / / 
#  >  <|   < (_| (_| |    / __/ (_) |/ /  
# /_/\_\_|\_\___\__,_|___|_____\___//_/   
#                   |_____|               

# based on XKCD 287 - https://xkcd.com/287/

defmodule Item do
  @moduledoc """
  Defines a struct for a menu item with a name and price
  """

  @type t :: %__MODULE__{
    name: String.t,
    price: Money.t
  }

  defstruct name: "", price: Money.new(1)

  @type menu() :: [t, ...]

  @spec new(String.t, Money.t) :: t
  @doc ~S"""
  Create a new `Item` struct with a name and price

  ## Examples

    iex> Item.new("grilled cheese", Money.parse!("$1.25"))
    %Item{name: "grilled cheese", price: %Money{amount: 125, currency: :USD}}

  """
  def new(name, %Money{amount: amount} = price) when amount > 0,
    do: %Item{name: name, price: price}

  @spec parse(String.t) :: {:ok, t}
  @doc ~S"""
  Parse a comma-separated string into name and price

  ## Examples

    iex> Item.parse("cheezborger,$2.50")
    %Item{name: "cheezborger", price: %Money{amount: 250, currency: :USD}}

    iex> Item.parse("caviar,$99.99")
    %Item{name: "caviar", price: %Money{amount: 9999, currency: :USD}}

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
    [%Item{name: "coffee", price: %Money{amount: 200, currency: :USD}},
     %Item{name: "tea", price: %Money{amount: 100, currency: :USD}},
     %Item{name: "me", price: %Money{amount: 999, currency: :USD}}]
  """
  def parse(menu_rows) when is_list(menu_rows) do
    Enum.map(menu_rows, fn r -> Item.parse(r) end)
  end

  @spec sort(menu()) :: menu()
  @doc ~S"""
  Sorts a list of menu items in descending price order

  ## Examples

    # iex> Enum.map(&(&1.price.amount))
    # iex> Enum.map(Item.parse(["last,$5.00","first,$1.00","middle,$3.00","second,$2.00","penultimate,$4.00"]))
    # [1,2,3]

    iex> Item.sort(Item.parse(["last,$5.00","first,$1.00","middle,$3.00","second,$2.00","penultimate,$4.00"]))
    [%Item{name: "last", price: %Money{amount: 500, currency: :USD}},
     %Item{name: "penultimate", price: %Money{amount: 400, currency: :USD}},
     %Item{name: "middle", price: %Money{amount: 300, currency: :USD}},
     %Item{name: "second", price: %Money{amount: 200, currency: :USD}},
     %Item{name: "first", price: %Money{amount: 100, currency: :USD}}]
  """
  def sort(menu) do
    Enum.sort(menu, &(Money.compare(&1.price, &2.price) != -1))
  end
end