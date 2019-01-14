defmodule Xkcd287.Mixfile do
  use Mix.Project

  def project do
    [app: :xkcd_287,
     version: "0.1.0",
     elixir: "~> 1.7",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Xkcd287],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :table_rex]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:optimus, "~> 0.1.0"},
      {:money, "~> 1.3"},
      {:table_rex, "~> 2.0.0"}
    ]
  end
end
