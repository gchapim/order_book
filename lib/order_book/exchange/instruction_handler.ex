defmodule OrderBook.Exchange.InstructionHandler do
  @moduledoc """
  Module responsible for validating and instruction and handling it.
  """

  alias OrderBook.{Exchange, Instruction}
  alias OrderBook.Exchange.Instruction.{Remover, Shifter, Updater}

  @spec handle(Instruction.t(), Exchange.stack()) :: map() | {:error, any()}
  def handle(
        %Instruction{instruction: :new} = instruction,
        stack
      ) do
    apply_operation(instruction, stack, Shifter)
  end

  def handle(
        %Instruction{instruction: :update} = instruction,
        stack
      ) do
    apply_operation(instruction, stack, Updater)
  end

  def handle(
        %Instruction{instruction: :delete} = instruction,
        stack
      ) do
    apply_operation(instruction, stack, Remover)
  end

  defp apply_operation(
         %Instruction{side: side} = instruction,
         stack,
         operator
       ) do
    with {:ok, side_stack} <-
           stack |> Map.get(side) |> operator.operate(to_exchange_instruction(instruction)),
         do: %{stack | side => side_stack}
  end

  defp to_exchange_instruction(instruction) do
    Map.take(instruction, [:price, :price_level_index, :quantity])
  end
end
