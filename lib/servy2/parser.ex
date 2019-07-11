defmodule Servy2.Parser do
  def parse(request) do
    # TODO: Parse the request string into a map:
    [ method, path, _protocol ] = 
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")
    %{ method: method,
       path: path,
       status: nil,
       resp_body: "" }
  end
end