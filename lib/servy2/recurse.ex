defmodule Servy2.Recurse do
  # meh
  def map([head | tail], function) do
    new_head = function.(head)
    map(tail, function, [new_head])
  end

  def map([head | tail], function, new_list) do
    new_head = function.(head)
    map(tail, function, [new_head | new_list])
  end

  def map([], _function, new_list), do: Enum.reverse(new_list)

  # better 
  def my_map([head | tail], fun) do
    return 
  [fun.(head) | my_map(tail, fun)]
  end

  def my_map([], _fun), do: []
end