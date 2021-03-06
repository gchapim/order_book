defmodule OrderBook.Exchange.Instruction.Shifter do
  @moduledoc """
  Responsible for handling the :new instruction over an Exchange.
  """

  @behaviour OrderBook.Exchange.Instruction.Operator

  @impl true
  def operate(stack, %{
        price_level_index: index,
        quantity: quantity,
        price: price
      }) do
    {:ok,
     stack
     |> shift(index, Map.get(stack, index))
     |> Map.put(index, %{quantity: quantity, price: price})}
  end

  def shift(map, _, nil), do: map

  def shift(map, pos, elem) do
    pos = pos + 1
    next_elem = Map.get(map, pos)

    map
    |> Map.put(pos, elem)
    |> shift(pos, next_elem)
  end
end
