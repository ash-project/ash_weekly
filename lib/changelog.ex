defmodule AshWeekly.Changelog do
  @header_regex ~r/## \[.*?\]\(.*?\) \((\d{4}-\d{2}-\d{2})\)/

  def parse_changelog(content) do
    headers = Regex.scan(@header_regex, content, capture: :all_but_first)

    today = Date.utc_today()
    seven_days_ago = Date.add(today, -7)

    headers
    |> Enum.reduce([], fn [date_str], acc ->
      release_date = Date.from_iso8601!(date_str)

      if Date.compare(seven_days_ago, release_date) in [:lt, :eq] and
           Date.compare(release_date, today) in [:lt, :eq] do
        [_, rest] = String.split(content, date_str, parts: 2)
        [_, rest] = String.split(rest, "\n", parts: 2)
        next_header_index = find_next_header_index(rest, 0)
        section = String.slice(rest, 0, next_header_index)
        [String.trim(section) | acc]
      else
        acc
      end
    end)
    |> Enum.reverse()
  end

  defp find_next_header_index(content, start_index) do
    case Regex.run(@header_regex, content, return: :index, offset: start_index) do
      nil -> String.length(content)
      [{index, _} | _] -> index
    end
  end
end
