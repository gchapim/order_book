defmodule OrderBook.Exchange.Instruction.ShifterTest do
  use ExUnit.Case, async: true

  alias OrderBook.Exchange.Instruction.Shifter

  @instruction_attrs %{
    price_level_index: 2,
    price: 70.0,
    quantity: 20
  }

  test "operate/2 :new instruction with empty stack" do
    assert %{2 => %{quantity: 20, price: 70.0}} = Shifter.operate(%{}, @instruction_attrs)
  end

  test "operate/2 :new instruction with colliding price levels" do
    map =
      2..5
      |> Enum.reduce(%{}, fn index, acc ->
        Shifter.operate(acc, %{
          price_level_index: index,
          quantity: index,
          price: 2.0
        })
      end)
      |> Shifter.operate(%{
        price_level_index: 7,
        quantity: 7,
        price: 2.0
      })

    assert %{
             2 => %{price: 2.0, quantity: 2},
             3 => %{price: 10.0, quantity: 10},
             4 => %{price: 2.0, quantity: 3},
             5 => %{price: 2.0, quantity: 4},
             6 => %{price: 2.0, quantity: 5},
             7 => %{price: 2.0, quantity: 7}
           } =
             Shifter.operate(map, %{
               price_level_index: 3,
               quantity: 10,
               price: 10.0
             })
  end
end
