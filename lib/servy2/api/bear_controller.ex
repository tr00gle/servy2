defmodule Servy2.Api.BearController do
  
  def index(conv) do
    json = 
      Servy2.Wildthings.list_bears()
      |> Poison.encode!
    resp_headers = Map.put(conv.resp_headers, :content_type, "application/json")
    %{ conv | status: 200, resp_headers: resp_headers, resp_body: json }
  end
end