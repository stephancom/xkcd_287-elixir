defmodule ItemTest do
  use ExUnit.Case
  doctest Item

  test "forbids negative price" do
    assert_raise FunctionClauseError, fn ->
      Item.new("no tea", Money.parse!("-$2.99"))
    end
  end

  test "parse forbids malformed string" do
    assert_raise ArgumentError, fn ->
      Item.parse("haggis is £2.30")
    end
  end

  test "parse fails on reversed string" do
    assert_raise ArgumentError, fn ->
      Item.parse("$2.00,hamborger")
    end
  end
end