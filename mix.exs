defmodule AshWeekly.MixProject do
  use Mix.Project

  def project do
    [
      app: :ash_weekly,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      listeners: [Phoenix.CodeReloader]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AshWeekly.Application, []},
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
      # {:ash_phoenix, "~> 2.0"},
      # {:ash_postgres, "~> 2.0"},
      {:ash_phoenix, github: "ash-project/ash_phoenix", override: true},
      {:ash_postgres, github: "ash-project/ash_postgres", override: true},
      {:sourceror, "~> 1.8", only: [:dev, :test]},
      {:ash_ai, "~> 0.1"},
      # {:ash, "~> 3.0"},
      {:ash, github: "ash-project/ash", override: true},
      {:tidewave, "~> 0.1", only: [:dev]},
      {:phoenix, "~> 1.8.0-rc.3", override: true},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0.9"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.9", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.16"},
      {:req, "~> 0.5"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"},
      {:timex, "~> 3.0"},
      {:igniter, "~> 0.5", only: [:dev, :test]}
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
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ash.setup --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind ash_weekly", "esbuild ash_weekly"],
      "assets.deploy": [
        "tailwind ash_weekly --minify",
        "esbuild ash_weekly --minify",
        "phx.digest"
      ],
      "ash_weekly.report": fn _ ->
        Mix.Task.run("compile")
        Mix.Task.run("app.start")
        AshWeekly.report()
      end,
      "ash_weekly.check_for_releases": fn _ ->
        Mix.Task.run("compile")
        Mix.Task.run("app.start")
        AshWeekly.check_for_releases()
      end,
      "ash_weekly.open_all": fn _ ->
        Mix.Task.run("compile")
        Mix.Task.run("app.start")
        AshWeekly.open_all()
      end
    ]
  end
end
