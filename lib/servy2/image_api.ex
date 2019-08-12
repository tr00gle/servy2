defmodule Servy2.ImageAPI do
  def query(image_id) do
    api_url(image_id)
    |> HTTPoison.get
    |> handle_response
  end

  defp api_url(id) do
    "https://api.myjson.com/bins/#{URI.encode(id)}"
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    image_url = 
      body
      |> Poison.Parser.parse!(%{})
      |> get_in(["image", "image_url"])
    {:ok, image_url}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: _status_code, body: body}}) do
    message = 
      body
      |> Poison.Parser.parse!(%{})
      |> get_in(["message"])
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end