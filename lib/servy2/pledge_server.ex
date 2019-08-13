defmodule Servy2.PledgeServer do
  def listen_loop(state) do
    IO.puts("waiting for a message...")

    receive do
      {:create_pledge, name, amount} ->
        {:ok, id} = send_pledges_to_service(name, amount)
        new_state = [{name, amount} | state]
        List.pop_at(new_state, -1)
        IO.puts("sent pledge #{id} to service")
        IO.puts("new state is #{inspect(new_state)}")
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send(sender, {:response, state})
        IO.puts("sent pledges to #{inspect(sender)}")
        listen_loop(state)
    end
  end

  def create_pledge(name, amount) do
    {:ok, id} = send_pledges_to_service(name, amount)
  end

  def recent_pledges do
  end

  defp send_pledges_to_service(_name, _amount) do
    # additional code goes here
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
