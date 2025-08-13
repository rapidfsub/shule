defmodule Simons.MixProject do
  use Mix.Project

  def project do
    [
      app: :simons,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: Enum.concat([deps(), dev_deps()])
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, ">= 0.0.0"},
      {:explorer, ">= 0.0.0"}
    ]
  end

  defp dev_deps() do
    [
      {:igniter, ">= 0.0.0", only: [:dev, :test]}
    ]
  end
end
