defmodule OrderBook.Exchange.InstructionHandler do
  @moduledoc """
  Module responsible for validating and instruction and handling it.
  """

  alias OrderBook.Instruction

  def handle(instruction_attrs, stack) do
    with {:ok, %Instruction{} = instruction} <- Instruction.build(instruction_attrs) do
      # do_handle(instruction, stack)
    end
  end
end
