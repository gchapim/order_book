defmodule OrderBook.Exchange.InstructionHandlerTest do
  use ExUnit.Case, async: true

  alias OrderBook.Exchange.InstructionHandler
  alias OrderBook.Instruction

  @instruction_attrs %Instruction{
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

  setup do
    %{instruction: @instruction_attrs}
  end

  describe "new" do
    test "handle/2 with ask" do
      assert %{
               bid: @bid_stack,
               ask: %{1 => %{quantity: 1, price: 10.0}, 2 => %{quantity: 20, price: 70.0}}
             } = InstructionHandler.handle(@instruction_attrs, @stack)
    end

    test "handle/2 with bid" do
      assert %{
               ask: @ask_stack,
               bid: %{1 => %{quantity: 3, price: 70.0}, 2 => %{quantity: 20, price: 70.0}}
             } = InstructionHandler.handle(%{@instruction_attrs | side: :bid}, @stack)
    end
  end

  describe "update" do
    setup :update

    test "handle/2 with ask", %{instruction: instruction} do
      assert %{
               bid: @bid_stack,
               ask: %{1 => %{quantity: 20, price: 70.0}}
             } = InstructionHandler.handle(%{instruction | price_level_index: 1}, @stack)
    end

    test "handle/2 with bid", %{instruction: instruction} do
      assert %{
               ask: @ask_stack,
               bid: %{1 => %{quantity: 20, price: 70.0}}
             } =
               InstructionHandler.handle(
                 %{instruction | side: :bid, price_level_index: 1},
                 @stack
               )
    end
  end

  describe "delete" do
    setup :delete

    test "handle/2 with ask", %{instruction: instruction} do
      assert %{
               bid: @bid_stack,
               ask: %{}
             } = InstructionHandler.handle(%{instruction | price_level_index: 1}, @stack)
    end

    test "handle/2 with bid", %{instruction: instruction} do
      assert %{
               ask: @ask_stack,
               bid: %{}
             } =
               InstructionHandler.handle(
                 %{instruction | side: :bid, price_level_index: 1},
                 @stack
               )
    end
  end

  defp update(context) do
    put_in_instruction(context, :update)
  end

  defp delete(context) do
    put_in_instruction(context, :delete)
  end

  defp put_in_instruction(context, instruction_value) do
    Map.update!(context, :instruction, fn instruction ->
      %Instruction{instruction | instruction: instruction_value}
    end)
  end
end
