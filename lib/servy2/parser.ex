defmodule Servy2.Parser do

  alias Servy2.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")
    [request_line | header_lines] = String.split(top, "\n")
    [method, path, _protocol] = String.split(request_line, " ")
    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], params_string)
    %Conv{ method: method, path: path, params: params, headers: headers }
  end

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string
    |> String.trim
    |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(line, headers_map) ->
      [key, value] = String.split(line, ": ")
      Map.put(headers_map, key, value)
    end)
  end
end
