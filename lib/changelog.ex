defmodule AshWeekly.Changelog do
  @header_regex ~r/## (?:\[.*?\]\(.*?\)|v\d+\.\d+\.\d+) \((\d{4}-\d{2}-\d{2})\)/

  def parse_changelog(content, as_of) do
    [_content, content] = String.split(content, "<!-- changelog -->", parts: 2)
    headers = Regex.split(@header_regex, content, include_captures: true)

    headers
    |> Enum.drop(1)
    |> Enum.chunk_every(2)
    |> Enum.filter(fn
      [header, _contents] ->
        case Regex.run(@header_regex, header) do
          [_, date_str] ->
            case Date.from_iso8601(date_str) do
              {:ok, date} ->
                Date.compare(date, as_of) in [:gt, :eq]

              _ ->
                false
            end

          _ ->
            false
        end

      _ ->
        false
    end)
    |> Enum.map_join("\n", fn [header, contents] ->
      """
      #{header}

      #{contents}
      """
    end)
  end
end
