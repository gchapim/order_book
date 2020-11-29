defmodule OrderBook.Exchange.Instruction.UpdaterTest do
  use ExUnit.Case, async: true

  alias OrderBook.Exchange.Instruction.Updater

  @instruction_attrs %{
    price_level_index: 2,
    price: 70.0,
    quantity: 20
  }

  test "operate/2 instruction with empty stack" do
    assert {:error, [not_found: 2]} = Updater.operate(%{}, @instruction_attrs)
  end

  test "operate/2 instruction with existing price level" do
    assert {:ok,
            %{
              2 => %{price: 10.0, quantity: 10}
            }} =
             Updater.operate(%{2 => @instruction_attrs}, %{
               price_level_index: 2,
               quantity: 10,
               price: 10.0
             })
  end
end
