defmodule Xkcd287 do
  @moduledoc """
  Documentation for Xkcd287.
  """

  # @doc """
  # Hello world.

  # ## Examples

  #     iex> Xkcd287.hello
  #     :world

  # """
  def parsefile(opts) do
    [total | menu_rows] = File.read!(opts.args.infile) |> String.split("\n", trim: true)
    total = if opts.options.total do
              opts.options.total
            else
              Money.parse!(total)
            end
    unless Money.positive?(total) do
      raise "desired total cannot be negative"
    end
    menu = Enum.map(menu_rows, fn r -> Item.parse(r) end)
    {total, menu}
  end

  def findorders({total, menu}) do
    total |> IO.inspect
    menu |> IO.inspect
  end

  def main(argv) do
    Optimus.new!(
      name: "xkcd_287",
      description: "Exact order calculator",
      version: "0.1.0",
      author: "stephan.com stephan@stephan.com",
      about: "Given an input file containing a target total and menu items, find all possible combinations of menu items that meet the total exactly",
      allow_unknown_args: false,
      parse_double_dash: true,
      args: [
        infile: [
          value_name: "INPUT_FILE",
          help: "File with target total and lines of comma separated menu items",
          required: true,
          parser: :string
        ]
      ],
      flags: [],
      options: [
        total: [
          value_name: "TOTAL",
          short: "-t",
          long: "--total",
          help: "overide total in the input file",
          parser: fn(s) ->
                    Money.parse(s)
                  end,
          required: false
        ]
      ]
    ) |> Optimus.parse!(argv) |> parsefile |> findorders
  end
end
