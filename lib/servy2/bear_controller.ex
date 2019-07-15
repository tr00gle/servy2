defmodule Servy2.BearController do

  alias Servy2.Wildthings
  alias Servy2.Bear

  import Servy2.View, only: [render: 3]
  
  def index(conv) do
    bears = 
      Wildthings.list_bears()
      |> Enum.sort(&Bear.sort_asc_by_name/2)
    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end

  def delete(conv, _params) do
    %{ conv | status: 403, resp_body: "deleting bears is forbidden!" }
  end
end