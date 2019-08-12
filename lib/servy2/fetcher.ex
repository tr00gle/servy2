defmodule Servy2.Fetcher do
  def async(camera_name) do
    caller = self()

    spawn(fn -> send(parent, {:result, self(), Servy2.VideoCam.get_snapshot()}) end)
  end

  def get_result(pid) do
    receive do
      {^pid, :result, filename} -> filename
    end
  end
end
