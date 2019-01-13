defmodule Item do
  @moduledoc """
  Defines a struct for a menu item with a name and price
  """

  @type t :: %__MODULE__{
    name: String.t,
    price: Money.t
  }

  defstruct name: "food item", price: Money.new(1) 

  @spec new(String.t, Money.t) :: t
  @doc ~S"""
  Create a new `Item` struct with a name and price
  """
  def new(name, price),
    do: %Item{name: name, price: price}

  @spec parse(String.t) :: {:ok, t}
  @doc ~S"""
  Parse a comma-separated string into name and price
  """
  def parse(string) do
    [name | price] = String.split(string, ",", parts: 2)
    new(name, Money.parse!(hd(price)))
  end
end