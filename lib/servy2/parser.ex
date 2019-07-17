defmodule Servy2.Parser do

  alias Servy2.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n")
    [request_line | header_lines] = String.split(top, "\r\n")
    [method, path, _protocol] = String.split(request_line, " ")
    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], params_string)
    %Conv{ method: method, path: path, params: params, headers: headers }
  end

  @doc """
  Parses the given param string of the form `key1=value1&key2=value2` 
  into a map with corresponding keys and values.

  ## Examples
      iex> params_string = "name=Baloo&type=Brown"
      iex> Servy2.Parser.parse_params("application/x-www-form-urlencoded", params_string)
      %{"name" => "Baloo", "type" => "Brown"}
      iex> Servy2.Parser.parse_params("multipart/form-data", params_string)
      %{}
  """

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string
    |> String.trim
    |> URI.decode_query
  end

  def parse_params("application/json", params_string) do
     Poison.Parser.parse!(params_string, %{})
  end


  def parse_params(_, _), do: %{}

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(line, headers_map) ->
      [key, value] = String.split(line, ": ")
      Map.put(headers_map, key, value)
    end)
  end
end
