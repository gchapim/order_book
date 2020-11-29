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

  @bid_stack %{1 => %{quantity: 3, price: 70.0}}
  @ask_stack %{1 => %{quantity: 1, price: 10.0}}

  @stack %{
    bid: @bid_stack,
    ask: @ask_stack
  }

  test "handle/2 validates instruction" do
    assert {:error, %Ecto.Changeset{}} =
             InstructionHandler.handle(%{}, %{@instruction_attrs | instruction: nil})
  end

  test "handle/2 with ask new instruction" do
    assert %{
             bid: @bid_stack,
             ask: %{1 => %{quantity: 1, price: 10.0}, 2 => %{quantity: 20, price: 70.0}}
           } = InstructionHandler.handle(@instruction_attrs, @stack)
  end

  test "handle/2 with bid new instruction" do
    assert %{
             ask: @ask_stack,
             bid: %{1 => %{quantity: 3, price: 70.0}, 2 => %{quantity: 20, price: 70.0}}
           } = InstructionHandler.handle(%{@instruction_attrs | side: :bid}, @stack)
  end
end
