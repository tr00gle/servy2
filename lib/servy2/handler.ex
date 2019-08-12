defmodule Servy2.Handler do
  @moduledoc """
    Handles HTTP Requests
  """

  import Servy2.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy2.Parser, only: [parse: 1]

  alias Servy2.Conv
  alias Servy2.BearController
  alias Servy2.VideoCam
  alias Servy2.Fetcher

  require Logger

  # @pages_path Path.expand("../../pages", __DIR__)
  # Use this method when compiling with `iex -S mix`
  @pages_path Path.expand("pages", File.cwd!())

  @doc "transforms request into a response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    # |> emojify
    |> put_content_length_header
    |> format_response
  end

  def emojify(%Conv{status: 200} = conv) do
    body = "✅✅✅\n" <> conv.resp_body <> "\n✅✅✅"
    %{conv | resp_body: body}
  end

  def emojify(%Conv{} = conv), do: conv

  def route(%Conv{method: "GET", path: "/kaboom"}) do
    raise "kabooooooom!"
  end

  def route(%Conv{method: "GET", path: "/sensors"} = conv) do
    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Fetcher.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Fetcher.get_result/1)

    %{conv | status: 200, resp_body: inspect(snapshots)}
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time
    |> String.to_integer()
    |> :timer.sleep()

    %{conv | status: 200, resp_body: "Awake!"}
  end

  def route(%Conv{method: "GET", path: "/pages/" <> page} = conv) do
    @pages_path
    |> Path.join(page <> ".html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Servy2.Api.BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy2.Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    BearController.delete(conv, conv.params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: _method, path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def put_content_length_header(conv) do
    headers = Map.put(conv.resp_headers, "Content-Length", byte_size(conv.resp_body))
    %{conv | resp_headers: headers}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv)}
    \r
    #{conv.resp_body}
    """
  end

  defp format_response_headers(%Conv{} = conv) do
    for {key, value} <- conv.resp_headers do
      "#{key}: #{value}\r"
    end
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp handle_file({:ok, content}, %Conv{} = conv) do
    %{conv | status: 200, resp_body: content}
  end

  defp handle_file({:error, :enoent}, %Conv{} = conv) do
    Logger.info("File missing, inserting default string")
    %{conv | status: 404, resp_body: "file not found. sorry bout that"}
  end

  defp handle_file({:error, reason}, %Conv{} = conv) do
    Logger.warn("There was some other erorr")
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end
end
