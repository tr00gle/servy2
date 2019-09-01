defmodule Servy2.PledgeServer do
  @name :pledge_server

  def start do
    IO.puts("starting the pledge server...")
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @name)
    pid
  end

  def listen_loop(state) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledges_to_service(name, amount)
        most_recent = Enum.take(state, 2)
        new_state = [{name, amount} | most_recent]
        listen_loop(new_state)
        send(sender, {:response, id})

      {sender, :recent_pledges} ->
        send(sender, {:response, state})
        listen_loop(state)
    end
  end

  def create_pledge(name, amount) do
    send(@name, {self(), :create_pledge, name, amount})

    receive do
      {:response, status} -> status
    end
  end

  def recent_pledges do
    send(@name, {self(), :recent_pledges})

    receive do
      {:response, pledges} -> pledges
    end
  end

  defp send_pledges_to_service(_name, _amount) do
    # additional code goes here
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
