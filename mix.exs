defmodule AshWeekly.MixProject do
  use Mix.Project

  def project do
    [
      app: :ash_weekly,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases() do
    [
      "ash_weekly.report": fn _ ->
        Mix.Task.run("compile")
        Mix.Task.run("app.start")
        AshWeekly.report()
      end,
      "ash_weekly.open_all": fn _ ->
        Mix.Task.run("compile")
        Mix.Task.run("app.start")
        AshWeekly.open_all()
      end
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:timex, "~> 3.0"},
      {:sweet_xml, "~> 0.7"},
      {:req, "~> 0.5"},
      {:igniter, "~> 0.5", only: [:dev, :test]}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
