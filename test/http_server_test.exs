defmodule HTTPServerTest do
  @moduledoc """
  Tests for the HTTP Server module.
  More tests here, please.
  Even more tests, please.
  """
  use ExUnit.Case

  alias Servy2.HTTPServer
  alias Servy2.HTTPClient

  test "accepts a request on a socket and sends back a response" do
    spawn(HTTPServer, :start, [4000])

    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = HTTPClient.send_request(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Bears, Lions, Tigers
           """
  end
end
