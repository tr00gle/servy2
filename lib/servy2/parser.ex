defmodule Servy2.Parser do

  alias Servy2.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")
    [ request_line | headers ] = String.split(top, "\n")
    [ method, path, _protocol ] = String.split(request_line, " ")
    params = parse_params(params_string)
    %Conv{ method: method, path: path, params: params }
  end

  def parse_params(params_string) do
    params_string
    |> String.trim
    |> URI.decode_query
  end
end