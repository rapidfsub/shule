defmodule Emil.MixProject do
  use Mix.Project

  def project do
    [
      app: :emil,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      # consolidate_protocols: Mix.env() != :dev,
      consolidate_protocols: Mix.env() not in [:dev, :test],
      aliases: List.flatten([phx_aliases(), aliases()]) |> Keyword.new(),
      deps: List.flatten([deps(), local_deps(), dev_deps(), phx_deps()])
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Emil.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ash, ">= 0.0.0"},
      {:ash_authentication, ">= 0.0.0"},
      {:ash_oban, ">= 0.0.0"},
      {:ash_phoenix, ">= 0.0.0"},
      {:ash_postgres, ">= 0.0.0"},
      {:ash_state_machine, ">= 0.0.0"},
      {:decimal, ">= 0.0.0"},
      {:faker, ">= 0.0.0"},
      {:oban, ">= 0.0.0"},
      {:picosat_elixir, ">= 0.0.0"}
    ]
  end

  defp local_deps() do
    [
      {:mixin, path: "../mixin"}
    ]
  end

  defp dev_deps() do
    [
      {:igniter, ">= 0.0.0", only: [:dev, :test]},
      {:sourceror, ">= 0.0.0", only: [:dev, :test]}
    ]
  end

  defp phx_deps() do
    [
      {:phoenix, ">= 0.0.0"},
      {:phoenix_ecto, ">= 0.0.0"},
      {:ecto_sql, ">= 0.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, ">= 0.0.0"},
      {:phoenix_live_reload, ">= 0.0.0", only: :dev},
      {:phoenix_live_view, ">= 0.0.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, ">= 0.0.0"},
      {:esbuild, ">= 0.0.0", runtime: Mix.env() == :dev},
      {:tailwind, ">= 0.0.0", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, ">= 0.0.0"},
      {:finch, ">= 0.0.0"},
      {:telemetry_metrics, ">= 0.0.0"},
      {:telemetry_poller, ">= 0.0.0"},
      {:gettext, ">= 0.0.0"},
      {:jason, ">= 0.0.0"},
      {:dns_cluster, ">= 0.0.0"},
      {:bandit, ">= 0.0.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ash.setup", "assets.setup", "assets.build", "run priv/repo/seeds.exs"],
      test: ["ash.setup --quiet", "test"]
    ]
  end

  defp phx_aliases() do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind emil", "esbuild emil"],
      "assets.deploy": [
        "tailwind emil --minify",
        "esbuild emil --minify",
        "phx.digest"
      ]
    ]
  end
end
