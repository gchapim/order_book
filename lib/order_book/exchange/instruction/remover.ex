defmodule OrderBook.Exchange.Instruction.Remover do
  @moduledoc """
  Responsible for handling the :new instruction over an Exchange.
  """

  @behaviour OrderBook.Exchange.Instruction.Operator

  @impl true
  def operate(stack, %{
        price_level_index: index
      }) do
    stack
    |> Map.delete(index)
    |> shift_down(index, Map.get(stack, index + 1))
  end

  def shift_down(map, index, nil), do: Map.delete(map, index)

  def shift_down(map, pos, elem) do
    pos = pos + 1
    next_elem = Map.get(map, pos + 1)

    map
    |> Map.put(pos - 1, elem)
    |> shift_down(pos, next_elem)
  end
end
