defmodule Servy2.Api.BearController do
  def index(conv) do
    json =
      Servy2.Wildthings.list_bears()
      |> Poison.encode!()

    resp_headers = Map.put(conv.resp_headers, "Content-Type", "application/json")
    %{conv | status: 200, resp_headers: resp_headers, resp_body: json}
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end
end
