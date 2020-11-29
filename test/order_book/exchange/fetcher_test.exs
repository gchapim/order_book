defmodule OrderBook.Exchange.FetcherTest do
  use ExUnit.Case, async: true

  alias OrderBook.Exchange.Fetcher

  @order_book %{
    ask: %{
      1 => %{price: 1.0, quantity: 1},
      2 => %{price: 2.0, quantity: 2},
      3 => %{price: 3.0, quantity: 3}
    },
    bid: %{
      1 => %{price: 10.0, quantity: 10},
      2 => %{price: 20.0, quantity: 30}
    }
  }

  test "fetch/2 with invalid level" do
    assert {:error, :argument_error} = Fetcher.fetch(@order_book, nil)
  end

  test "fetch/2 with valid" do
    assert [
             %{ask_price: 1.0, ask_quantity: 1, bid_price: 10.0, bid_quantity: 10},
             %{ask_price: 2.0, ask_quantity: 2, bid_price: 20.0, bid_quantity: 30}
           ] = Fetcher.fetch(@order_book, 2)
  end

  test "fetch/2 with undefined side" do
    assert [
             %{ask_price: 1.0, ask_quantity: 1, bid_price: 10.0, bid_quantity: 10},
             %{ask_price: 2.0, ask_quantity: 2, bid_price: 20.0, bid_quantity: 30},
             %{ask_price: 3.0, ask_quantity: 3, bid_price: nil, bid_quantity: nil}
           ] = Fetcher.fetch(@order_book, 3)
  end
end
