defmodule AshWeekly do
  @moduledoc """
  Documentation for `AshWeekly`.
  """

  @repos [
    "ash-project/ash",
    "ash-project/reactor",
    "ash-project/igniter",
    "ash-project/spark",
    "ash-project/splode",
    "ash-project/ash_graphql",
    "ash-project/ash_json_api",
    "team-alembic/ash_authentication",
    "team-alembic/ash_authentication_phoenix",
    "ash-project/ash_postgres",
    "ash-project/ash_sql",
    "ash-project/ash_sqlite",
    "ash-project/ash_csv",
    "ash-project/ash_admin",
    "ash-project/ash_appsignal",
    "ash-project/opentelemetry_ash",
    "ash-project/ash_archival",
    "ash-project/ash_cloak",
    "ash-project/ash_money",
    "ash-project/ash_oban",
    "ash-project/ash_paper_trail",
    "ash-project/ash_double_entry",
    "ash-project/ash_phoenix",
    "ash-project/ash_slug",
    "ash-project/iterex"
  ]

  def open_all do
    Enum.each(@repos, &System.cmd("open", ["https://github.com/#{&1}"]))
  end

  def report do
    rss_url = "https://ashweekly.substack.com/feed.rss"
    {:ok, %{body: rss_body}} = Req.get(rss_url)
    import SweetXml

    latest_date =
      rss_body
      |> xpath(~x"//item/pubDate/text()"l)
      |> Enum.map(&List.to_string/1)
      |> Enum.map(&Timex.parse!(&1, "{RFC1123}"))
      |> Enum.max(Timex.Comparable)
      |> case do
        ~U[2025-01-18 17:14:45Z] ->
          DateTime.shift(DateTime.utc_now(), day: -7)

        date ->
          date
      end
      |> DateTime.to_date()

    @repos
    |> Enum.map_join("\n\n", fn repo ->
      url = "https://raw.githubusercontent.com/#{repo}/main/CHANGELOG.md"

      text = Req.get!(url).body
      changes = AshWeekly.Changelog.parse_changelog(text, latest_date)

      if String.trim(changes) == "" do
        ""
      else
        "# #{repo}\n\n#{changes}"
      end
    end)
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n")
    |> then(fn str ->
      """
      For any versions published on the same day as the last newsletter, 
      you'll have to manually check if they were included in the last newsletter!

      Don't forget :)


      """
    end)
    |> Kernel.<>(
      "\nNow go to the `ash-weekly` discord channel and check for any updates since the last ash-weekly post"
    )
    |> Kernel.<>("\nPost to reddit.com/r/elixir")
    |> Kernel.<>("\nPost to https://elixirforum.com/t/ash-weekly-newsletter/68818")
    |> Kernel.<>("\nPost to discord")
    |> then(&File.write!("report.md", &1))

    IO.puts("'./report.md` created")
  end
end
