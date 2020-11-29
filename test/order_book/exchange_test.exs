defmodule OrderBook.ExchangeTest do
  use ExUnit.Case, async: true

  alias OrderBook.Exchange

  @valid_instruction %{
    instruction: :new,
    side: :ask,
    price_level_index: 1,
    price: 70.0,
    quantity: 20
  }

  setup do
    %{exchange: start_supervised!(Exchange)}
  end

  test "send_instruction/2 adds an instruction with valid params", %{exchange: exchange} do
    assert :ok = Exchange.send_instruction(exchange, @valid_instruction)
  end

  test "send_instruction/2 returns validation errors", %{exchange: exchange} do
    assert {:error, %Ecto.Changeset{}} = Exchange.send_instruction(exchange, %{})
  end

  test "order_book/2", %{exchange: exchange} do
    assert [%{ask_price: nil, ask_quantity: nil, bid_price: nil, bid_quantity: nil}] =
             Exchange.order_book(exchange, 1)
  end
end
