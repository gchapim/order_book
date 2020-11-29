defmodule OrderBook.Exchange.Instruction.RemoverTest do
  use ExUnit.Case, async: true

  alias OrderBook.Exchange.Instruction.Remover

  @instruction_attrs %{
    price_level_index: 2
  }

  test "operate/2 instruction with empty stack" do
    assert %{} = Remover.operate(%{}, @instruction_attrs)
  end

  test "operate/2 instruction with one elem stack" do
    assert %{} = Remover.operate(%{2 => %{price: 2.0, quantity: 2}}, @instruction_attrs)
  end

  test "operate/2 instruction with colliding price levels" do
    map = %{
      2 => %{price: 2.0, quantity: 2},
      3 => %{price: 2.0, quantity: 3},
      4 => %{price: 2.0, quantity: 4},
      5 => %{price: 2.0, quantity: 5},
      6 => %{price: 2.0, quantity: 6},
      8 => %{price: 2.0, quantity: 8}
    }

    assert %{
             2 => %{price: 2.0, quantity: 2},
             3 => %{price: 2.0, quantity: 4},
             4 => %{price: 2.0, quantity: 5},
             5 => %{price: 2.0, quantity: 6},
             8 => %{price: 2.0, quantity: 8}
           } ==
             Remover.operate(map, %{
               price_level_index: 3
             })
  end
end
