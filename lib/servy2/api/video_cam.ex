defmodule Servy2.VideoCam do
  @doc """
    Simulates sending a request to an external API 
    to get a snapshot image from a video camera
  """
  def get_snapshot(camera_name) do
    
    # sleep 2 seconds to simulate that the API can be slow
    :timer.sleep(5000)

    # example response returned from the API:
    "#{camera_name}-snapshot.jpg"
  end
end