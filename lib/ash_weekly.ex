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

  def check_for_releases do
    @repos
    |> Task.async_stream(
      fn repo ->
        [_org, project] = String.split(repo, "/")
        dir = "../#{project}"

        if !File.exists?(dir) do
          System.cmd("gh", ["repo", "clone", repo],
            cd: "..",
            stderr_to_stdout: true
          )
        end

        case System.cmd("git", ["status", "-s", "--porcelain"],
               stderr_to_stdout: true,
               cd: dir
             ) do
          {"", _} ->
            System.cmd("git", ["checkout", "main", "--porcelain"],
              cd: dir,
              stderr_to_stdout: true
            )

            {_, 0} =
              System.cmd("git", ["pull", "origin", "main"],
                cd: dir,
                stderr_to_stdout: true
              )

            System.cmd("mix", ["deps.get"], cd: dir, stderr_to_stdout: true)

            case System.cmd("mix", ["git_ops.release", "--dry-run"],
                   cd: dir,
                   stderr_to_stdout: true
                 ) do
              {output, _} ->
                if !String.contains?(
                     output,
                     "No changes should result in a new release version."
                   ) do
                  IO.ANSI.format([:yellow, project, " - Release", :reset])
                  |> Mix.shell().info()
                end
            end

          _ ->
            IO.ANSI.format([:red, project, " - Has local changes", :reset])
            |> Mix.shell().info()
        end
      end,
      timeout: :infinity,
      max_concurrency: 1
    )
    |> Stream.run()
  end

  def open_all do
    Enum.each(@repos, &System.cmd("open", ["https://github.com/#{&1}"]))
  end

  def report do
    one_week_ago = Date.shift(Date.utc_today(), day: -7)

    latest_date =
      case String.trim(
             Mix.shell().prompt(
               "When was the last newsletter? Default: #{one_week_ago}. YYYY-MM-DD"
             )
           ) do
        "" ->
          one_week_ago

        date ->
          Timex.parse!(date, "{YYYY}-{0M}-{0D}")
      end

    @repos
    |> Enum.map_join("\n\n\n", fn repo ->
      url = "https://raw.githubusercontent.com/#{repo}/main/CHANGELOG.md"

      text = Req.get!(url).body

      changes =
        AshWeekly.Changelog.parse_changelog(text, latest_date)
        |> String.split("\n")
        |> Enum.reject(&(&1 == ""))
        |> Enum.join("\n")

      if String.trim(changes) == "" do
        ""
      else
        "# #{repo}\n#{changes}"
      end
    end)
    |> then(fn str ->
      """
      For any versions published on the same day as the last newsletter, 
      you'll have to manually check if they were included in the last newsletter!

      Don't forget :)


      """ <> str
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
