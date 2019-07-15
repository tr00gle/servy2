defmodule Servy2.BearController do

  alias Servy2.Wildthings
  alias Servy2.Bear
  
  def index(conv) do
    bears_string = 
      Wildthings.list_bears()
      |> Enum.sort(&Bear.sort_asc_by_name/2)
      |> Enum.map(&make_bear_item/1)
      |> Enum.join
    %{ conv | status: 200, resp_body: "<ul>#{bears_string}</ul>" }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{ conv | status: 200, resp_body: "<h1>#{bear.name} - #{bear.type}</h1>" }
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end

  def delete(conv, _params) do
    %{ conv | status: 403, resp_body: "deleting bears is forbidden!" }
  end

  defp make_bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

end