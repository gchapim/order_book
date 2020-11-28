defmodule OrderBook.Exchange.Instruction.Shifter do
  @moduledoc """
  Responsible for handling the :new instruction over an Exchange.
  """

  def shift(stack, %{
        price_level_index: index,
        quantity: quantity,
        price: price
      }) do
    stack
    |> do_shift(index, Map.get(stack, index))
    |> Map.put(index, %{quantity: quantity, price: price})
  end

  def do_shift(map, _, nil), do: map

  def do_shift(map, pos, elem) do
    pos = pos + 1
    next_elem = Map.get(map, pos)

    map
    |> Map.put(pos, elem)
    |> do_shift(pos, next_elem)
  end
end
