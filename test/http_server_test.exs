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
    spawn(HTTPServer, :start, [4000])

    parent = self()

    max_concurrent_requests = 5

    # Spawn the client processes
    for _ <- 1..max_concurrent_requests do
      spawn(fn ->
        # Send the request
        {:ok, response} = HTTPoison.get("http://localhost:4000/wildthings")

        # Send the response back to the parent
        send(parent, {:ok, response})
      end)
    end

    # Await all {:handled, response} messages from spawned processes.
    for _ <- 1..max_concurrent_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Bears, Lions, Tigers"
      end
    end
  end
end
