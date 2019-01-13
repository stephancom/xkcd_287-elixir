defmodule Xkcd287 do
  @moduledoc """
  Documentation for Xkcd287.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Xkcd287.hello
      :world

  """
  def hello do
    :world
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
        restaurant_name: [
          value_name: "RESTAURANT_NAME",
          short: "-r",
          long: "--restaurant",
          help: "name of restaurant",
          parser: :string,
          required: false
        ],
        override_total: [
          value_name: "OVERRIDE_TOTAL",
          short: "-t",
          long: "--total",
          help: "overide total in the input file",
          parser: :float, # TODO: currency parse, range check
          required: false
        ],
        method: [
          value_name: "METHOD",
          short: "-m",
          long: "--method",
          help: "method to use (recursive or montecarlo)",
          parser: :string, # TODO: check in possible options, get options from global
          required: false,
          default: "recursive"
        ]
      ]
    ) |> Optimus.parse!(argv) |> IO.inspect
  end
end
