defmodule EntryTest do
  use ExUnit.Case
  doctest Entry

  test "forbids zero quantity" do
    assert_raise FunctionClauseError, fn ->
      Entry.new(Item.parse("caviar,$99.99"), 0)
    end
  end

  test "forbids negative quantity" do
    assert_raise FunctionClauseError, fn ->
      Entry.new(Item.parse("caviar,$99.99"), -2)
    end
  end
end