defmodule Cerradura.Mixfile do
  use Mix.Project

  def project do
    [app: :cerradura,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :exexif, :sweet_xml, :xml_builder, :geocoder]]
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
      {:sweet_xml, "~> 0.6.3"},
      {:xml_builder, "~> 0.0.8"},
      {:exexif, github: "am-kantox/exexif"},
      {:geocoder, github: "knrz/geocoder"},

      {:credo, "~> 0.4", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end
