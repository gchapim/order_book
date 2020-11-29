defmodule OrderBook.Exchange.Instruction.Operator do
  @moduledoc """
  Behaviour for a Instruction Operator
  """

  @type delete_instruction :: %{price_level_index: number()}
  @type exchange_instruction ::
          delete_instruction()
          | %{price: float(), price_level_index: number(), quantity: number()}

  @callback operate(map(), exchange_instruction()) :: map()
end
