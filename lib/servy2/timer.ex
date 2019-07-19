defmodule Servy2.Timer do
  def remind(reminder, time) do
    :timer.sleep(time * 1000)
    IO.puts(reminder)
  end
end

Servy2.Timer.remind("Stand Up", 5)
Servy2.Timer.remind("Sit Down", 10)
Servy2.Timer.remind("Fight, Fight, Fight", 15)
