defmodule Servy2.Comprehensions do
  
  def atomize_map_keys(%{} = map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end
end

defmodule Servy2.DeckOfCards do
  @ranks [ "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A" ]
  @suits [ "♣", "♦", "♥", "♠" ]
  @deck for suit <- @suits, rank <- @ranks, do: { suit, rank }

  def make_deck do
    for suit <- @suits, rank <- @ranks, do: { suit, rank }
  end

  def deal_hand(deck, size), do: Enum.take_random(deck, size)

  def deal_13 do
    @deck
    |> Enum.shuffle
    |> Enum.take(13)
    |> IO.inspect
  end
end