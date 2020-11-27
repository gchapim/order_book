defmodule OrderBook.ExchangeTest do
  use ExUnit.Case, async: true

  alias OrderBook.Exchange

  test "starts genserver" do
    assert {:ok, _pid} = Exchange.start_link()
  end
end
