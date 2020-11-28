defmodule OrderBook.PriceLevelTest do
  use ExUnit.Case, async: true

  alias OrderBook.PriceLevel

  @attrs %{ask_quantity: 1, ask_price: 30.0, bid_quantity: 3, bid_price: 40.0}

  test "struct" do
    assert %PriceLevel{
             ask_quantity: 1,
             ask_price: 30.0,
             bid_quantity: 3,
             bid_price: 40.0
           } = struct(PriceLevel, @attrs)
  end
end
