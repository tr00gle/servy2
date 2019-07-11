defmodule Servy2.Plugins do
  def rewrite_path(%{ path: "/wildlife" } = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%{ path: "/bears?id=" <> id } = conv) do
    %{ conv | path: "/bears/#{id}" }
  end

  def rewrite_path(%{ path: "/about" } = conv) do
    %{ conv | path: "/pages/about" }
  end

  def rewrite_path(%{ path: "/bears/new" } = conv) do
    %{ conv | path: "/pages/form" }
  end

  def rewrite_path(conv), do: conv

   @doc "logs 404'ed requests"
  def track(%{ status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is not a valid route"
    conv
  end

  def track(conv), do: conv

  def log(conv), do: IO.inspect conv
end