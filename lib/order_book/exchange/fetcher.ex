defmodule OrderBook.Exchange.Fetcher do
  @moduledoc """
  Fetches price levels by input depth
  """

  alias OrderBook.Exchange

  @spec fetch(Exchange.stack(), nil | number()) :: Exchange.level_order_book()
  def fetch(_, nil), do: {:error, :argument_error}

  def fetch(%{ask: ask_stack, bid: bid_stack}, price_level) do
    Enum.map(1..price_level, fn current_level ->
      %{
        ask_price: get_in(ask_stack, [current_level, :price]),
        ask_quantity: get_in(ask_stack, [current_level, :quantity]),
        bid_price: get_in(bid_stack, [current_level, :price]),
        bid_quantity: get_in(bid_stack, [current_level, :quantity])
      }
    end)
  end
end
