defmodule Servy2.Parser do

  alias Servy2.Conv

  def parse(request) do
    # TODO: Parse the request string into a map:
    [ method, path, _protocol ] = 
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")
    %Conv{ method: method, path: path }
  end
end