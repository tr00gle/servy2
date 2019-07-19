defmodule Servy2.Wildthings do
  alias Servy2.Bear

  def list_bears do
    Path.expand("../db", __DIR__)
    |> Path.join("bears.json")
    |> File.read()
    |> handle_file
    |> Map.get("bears")
  end

  defp handle_file({:ok, content}) do
    Poison.decode!(content, as: %{"bears" => [%Bear{}]})
  end

  defp handle_file({:error, _reason}) do
    %{"bears" => "Ooops. There was a bearror."}
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn b -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_bear
  end
end
