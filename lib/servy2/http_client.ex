defmodule Servy2.HttpClient do 
  def send_request(request) do
    localhost = 'localhost'
    {:ok, socket} = :gen_tcp.connect(localhost, 8000, [:binary, packet: :raw, active: false]) 
    :ok = :gen_tcp.send(socket, request)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    :ok = :gen_tcp.close(socket)
    handle_response(response)
  end

  def handle_response(response) do
    IO.puts response
  end
end
