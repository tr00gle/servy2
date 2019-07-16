defmodule Servy2.Plugins do

  alias Servy2.Conv

  def rewrite_path(%Conv{ path: "/wildlife" } = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{ path: "/bears?id=" <> id } = conv) do
    %{ conv | path: "/bears/#{id}" }
  end

  def rewrite_path(%Conv{ path: "/about" } = conv) do
    %{ conv | path: "/pages/about" }
  end

  def rewrite_path(%Conv{ path: "/bears/new" } = conv) do
    %{ conv | path: "/pages/form" }
  end

  def rewrite_path(conv), do: conv

   @doc "logs 404'ed requests"
  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env == :prod do
      IO.puts "Warning: #{path} is not a valid route"
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    if Mix.env != :test do
     IO.inspect conv
    end
    conv
  end
end