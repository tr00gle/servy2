defmodule HTTPServerTest do
  @moduledoc """
  Tests for the HTTP Server module.
  More tests here, please.
  Even more tests, please.
  """
  use ExUnit.Case

  alias Servy2.HTTPServer

  @tag :skip
  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4000])

    url = "http://localhost:4000/wildthings"

    1..5
    |> Enum.map(fn(_) -> Task.async(fn -> HTTPoison.get(url) end) end)
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, response}) do
    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end
end
