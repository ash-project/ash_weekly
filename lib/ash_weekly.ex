defmodule AshWeekly do
  @moduledoc """
  Documentation for `AshWeekly`.
  """

  @repos [
    "ash-project/ash"
    # Add more repositories here
  ]

  def open_all do
    Enum.each(@repos, &System.cmd("open", ["https://github.com/#{&1}"]))
  end

  def report do
    @repos
    |> Enum.map_join("\n\n", fn repo ->
      url = "https://raw.githubusercontent.com/#{repo}/main/CHANGELOG.md"

      text = Req.get!(url).body
      changes = AshWeekly.Changelog.parse_changelog(text)

      "# #{repo}\n\n#{changes}"
    end)
    |> then(&File.write!("report.md", &1))

    IO.puts("Report can be found at ./report.md")
  end
end
