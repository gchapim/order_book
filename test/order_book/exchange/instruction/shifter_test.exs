defmodule OrderBook.Exchange.Instruction.ShifterTest do
  use ExUnit.Case, async: true

  alias OrderBook.Exchange.Instruction.Shifter
  alias OrderBook.PriceLevel

  @instruction_attrs %{
    price_level_index: 2,
    price: 70.0,
    quantity: 20
  }

  test "shift/2 :new instruction with empty stack" do
    assert %{2 => %{quantity: 20, price: 70.0}} = Shifter.shift(%{}, @instruction_attrs)
  end

  test "shift/2 :new instruction with colliding price levels" do
    map =
      2..5
      |> Enum.reduce(%{}, fn index, acc ->
        Shifter.shift(acc, %{
          price_level_index: index,
          instruction: :new,
          quantity: index,
          price: 2.0,
          side: :ask
        })
      end)
      |> Shifter.shift(%{
        price_level_index: 7,
        instruction: :new,
        quantity: 7,
        price: 2.0,
        side: :ask
      })

    assert %{
             2 => %{price: 2.0, quantity: 2},
             3 => %{price: 10.0, quantity: 10},
             4 => %{price: 2.0, quantity: 3},
             5 => %{price: 2.0, quantity: 4},
             6 => %{price: 2.0, quantity: 5},
             7 => %{price: 2.0, quantity: 7}
           } =
             Shifter.shift(map, %{
               price_level_index: 3,
               instruction: :new,
               quantity: 10,
               price: 10.0,
               side: :ask
             })
  end
end
