defmodule OrderBook.Exchange.Instruction.Updater do
  @moduledoc """
  Responsible for handling the update instruction over an Exchange.
  """

  @behaviour OrderBook.Exchange.Instruction.Operator

  @impl true
  def operate(stack, %{
        price_level_index: index,
        quantity: quantity,
        price: price
      }) do
    {:ok, Map.replace!(stack, index, %{quantity: quantity, price: price})}
  rescue
    KeyError -> {:error, not_found: index}
  end
end
