defmodule Servy2 do
  @moduledoc """
  Documentation for Servy2.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Servy2.hello()
      :world

  """
  def hello(name) do
    "Hello, #{name}"
  end

  def hello, do: :world
end

IO.puts Servy2.hello("Stuff")