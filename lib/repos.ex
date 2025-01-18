defmodule AshWeekly.Repos do
  @repos [
    "ash-project/ash"
    # Add more repositories here
  ]

  def fetch_and_parse_changelogs do
    Enum.each(@repos, fn repo ->
      changes = AshWeekly.Changelog.parse_changelog(fetch_changelog(repo))
      IO.inspect(changes)
    end)
  end

  defp fetch_changelog(repo) do
    url = "https://raw.githubusercontent.com/#{repo}/main/CHANGELOG.md"

    Req.get!(url).body
  end
end
