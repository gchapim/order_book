defmodule OrderBook.Exchange.InstructionHandlerTest do
  use ExUnit.Case, async: true

  alias OrderBook.Exchange.InstructionHandler

  @instruction_attrs %{
    instruction: :new,
    side: :ask,
    price_level_index: 2,
    price: 70.0,
    quantity: 20
  }

  test "handle/2 validates instruction" do
    assert {:error, %Ecto.Changeset{}} =
             InstructionHandler.handle(%{}, %{@instruction_attrs | instruction: nil})
  end
end
