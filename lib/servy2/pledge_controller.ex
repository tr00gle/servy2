defmodule Servy2.PledgeController do
  def create(conv, %{"naem" => name, "amount" => amount}) do
    Servy2.PledgeServer.create_pledge(name, String.to_integer(amount))

    %{conv | status: 201, resp_body: "#{name} pledged #{amount}"}
  end

  def index(conv) do
    pledges = Servy2.PledgeServer.recent_pledges()

    %{conv | status: 200, resp_body: inspect(pledges)}
  end
end
