defmodule OrderBook.Exchange.InstructionHandler do
  @moduledoc """
  Module responsible for validating and instruction and handling it.
  """

  alias OrderBook.Instruction
  alias OrderBook.Exchange.Instruction.{Shifter}

  @type exchange_stack :: %{ask: map(), bid: map()}

  @spec handle(map(), exchange_stack()) :: map() | {:error, Ecto.Changeset.t()}
  def handle(instruction_attrs, stack) do
    with {:ok, %Instruction{} = instruction} <- Instruction.build(instruction_attrs) do
      do_handle(instruction, stack)
    end
  end

  defp do_handle(
         %Instruction{side: side, instruction: :new} = instruction,
         stack
       ) do
    side_stack = stack |> Map.get(side) |> Shifter.operate(to_exchange_instruction(instruction))

    %{stack | side => side_stack}
  end

  defp to_exchange_instruction(instruction) do
    Map.take(instruction, [:price, :price_level_index, :quantity])
  end
end
