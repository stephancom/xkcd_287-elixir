defmodule Xkcd287 do
  @moduledoc """
  Documentation for Xkcd287.
  """

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
    menu = Item.parse(menu_rows)
    {menu, total}
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
    ) |>
    Optimus.parse!(argv) |>
    parsefile |>
    Orderer.generate |> 
    Enum.each( fn order -> Entry.print(order) end)
  end
end
