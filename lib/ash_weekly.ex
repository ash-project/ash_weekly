defmodule AshWeekly do
  @repos [
    "ash-project/ash",
    "ash-project/ash_ai",
    "ash-project/usage_rules",
    "ash-project/reactor",
    "ash-project/reactor_req",
    "ash-project/reactor_file",
    "ash-project/reactor_process",
    "ash-project/igniter",
    "ash-project/spark",
    "ash-project/ash_ops",
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
    "ash-project/ash_rate_limiter",
    "ash-project/ash_cloak",
    "ash-project/ash_money",
    "ash-project/ash_oban",
    "ash-project/ash_state_machine",
    "ash-project/ash_paper_trail",
    "ash-project/ash_double_entry",
    "ash-project/ash_phoenix",
    "ash-project/ash_slug",
    "ash-project/ash_events",
    "ash-project/iterex"
  ]

  def llms_txt() do
    @repos
    |> Enum.map(fn repo ->
      String.split(repo, "/") |> Enum.at(1)
    end)
    |> Enum.map_join("\n", fn package ->
      Req.get!("https://hex2txt.fly.dev/#{package}/llms.txt").body
    end)
    |> then(&File.write("llms.txt", &1))
  end

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
      max_concurrency: 16
    )
    |> Stream.run()
  end

  def open_all do
    Enum.each(@repos, &System.cmd("open", ["https://github.com/#{&1}"]))
  end

  def update_dependabot_schedule(repos \\ @repos) do
    repos
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
            System.cmd("git", ["checkout", "main"],
              cd: dir,
              stderr_to_stdout: true
            )

            {_, 0} =
              System.cmd("git", ["pull", "origin", "main"],
                cd: dir,
                stderr_to_stdout: true
              )

            dependabot_path = Path.join(dir, ".github/dependabot.yml")

            if File.exists?(dependabot_path) do
              content = File.read!(dependabot_path)
              parsed = YamlElixir.read_from_string!(content)

              updated_content =
                parsed
                |> put_in(
                  ["updates"],
                  Enum.map(parsed["updates"] || [], fn update ->
                    put_in(update, ["schedule", "interval"], "monthly")
                  end)
                )

              yaml_content = Ymlr.document!(updated_content)
              File.write!(dependabot_path, yaml_content)

              {output, _} = System.cmd("git", ["diff", "--name-only"], cd: dir)

              if String.contains?(output, "dependabot.yml") do
                System.cmd("git", ["add", ".github/dependabot.yml"], cd: dir)

                System.cmd("git", ["commit", "-m", "Update dependabot schedule to monthly"],
                  cd: dir
                )

                System.cmd("git", ["push", "origin", "main"], cd: dir)

                IO.ANSI.format([
                  :green,
                  project,
                  " - Updated dependabot schedule to monthly and pushed",
                  :reset
                ])
                |> Mix.shell().info()
              else
                IO.ANSI.format([:yellow, project, " - Dependabot already set to monthly", :reset])
                |> Mix.shell().info()
              end
            else
              IO.ANSI.format([:yellow, project, " - No dependabot.yml found, skipping", :reset])
              |> Mix.shell().info()
            end

          _ ->
            IO.ANSI.format([:red, project, " - Has local changes, skipping", :reset])
            |> Mix.shell().info()
        end
      end,
      timeout: :infinity,
      max_concurrency: 16
    )
    |> Stream.run()
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

      Also, add next office hours link in advance.

      """ <> str
    end)
    |> Kernel.<>(
      "\nNow go to the `ash-weekly` discord channel and check for any updates since the last ash-weekly post"
    )
    |> Kernel.<>("\nPost to reddit.com/r/elixir")
    |> Kernel.<>("\nPost to https://elixirforum.com/t/ash-weekly-newsletter/68818")
    |> Kernel.<>("\nPost to discord")
    |> Kernel.<>("\nPost to alembic slack")
    |> Kernel.<>("\nPost to slack")
    |> Kernel.<>("\nPost to linkedin")
    |> then(&File.write!("report.md", &1))

    IO.puts("'./report.md` created")
  end
end
