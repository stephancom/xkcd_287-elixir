use Mix.Config

config :money,
  default_currency: :USD,
  separator: ".",
  delimeter: ",",
  symbol: true,
  symbol_on_right: false,
  symbol_space: false