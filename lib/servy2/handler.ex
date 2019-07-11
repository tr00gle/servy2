defmodule Servy2.Handler do
  require Logger

  @moduledoc """
    Handles HTTP Requests
  """

  # @pages_path Path.expand("../../pages", __DIR__)
  @pages_path Path.expand("pages", File.cwd!)

  import Servy2.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy2.Parser, only: [parse: 1]
  
  @doc "transforms request into a resposne"
  def handle(request) do
    request 
    |> parse 
    |> rewrite_path
    |> log
    |> route
    |> track
    |> emojify
    |> format_response
  end

  def emojify(%{status: 200 } = conv) do
    body = "✅✅✅\n" <> conv.resp_body <> "\n✅✅✅"
    %{ conv | resp_body: body } 
  end

  def emojify(conv), do: conv
  
  def route(%{ method: "GET", path: "/pages/" <> page } = conv) do
    @pages_path
    |> IO.inspect
    |> Path.join(page <> ".html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
  end

  def route(%{ method: "GET", path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(%{ method: "DELETE", path: "/bears/" <> _id } = conv) do
    %{ conv | status: 403, resp_body: "Sorry, we can't do deletions here."}
  end

  def route(%{ method: _method, path: path } = conv) do 
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(conv) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

  defp handle_file({:ok, content}, conv) do
    %{ conv | status: 200, resp_body: content }
  end
  
  defp handle_file({:error, :enoent}, conv) do
    Logger.info "File missing, inserting default string"
    %{conv | status: 404, resp_body: "file not found. sorry bout that" }
  end
  
  defp handle_file({:error, reason}, conv) do
    Logger.warn "There was some other erorr"
    %{conv | status: 500, resp_body: "File error: #{reason}" }
  end
end

# /wildthings
# GET
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy2.Handler.handle(request)
IO.puts response

# /bears
# GET
request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy2.Handler.handle(request)
IO.puts response

# /bears with params
request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy2.Handler.handle(request)
IO.puts response

request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy2.Handler.handle(request)
IO.puts response

# /bears/new form 
request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy2.Handler.handle(request)
IO.puts response

# DELETE
request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy2.Handler.handle(request)
IO.puts response

# /bigfoot
# GET
request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy2.Handler.handle(request)
IO.puts response

# /about
request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy2.Handler.handle(request)
IO.puts response
