defmodule OrderBook.Exchange.Fetcher do
  @moduledoc """
  Fetches price levels by input depth
  """

  alias OrderBook.Exchange

  @doc """
  Fetches all instruction levels for a given depth and stack.

  ## Examples

    iex> Fetcher.fetch(
    ...>   %{
    ...>     ask: %{
    ...>       1 => %{quantity: 10, price: 1.0},
    ...>       2 => %{quantity: 20, price: 2.0}
    ...>     },
    ...>     bid: %{
    ...>       1 => %{quantity: 1, price: 1.0}
    ...>     }
    ...>   },
    ...>   2
    ...> )
    [
      %{ask_price: 1.0, ask_quantity: 10, bid_price: 1.0, bid_quantity: 1},
      %{ask_price: 2.0, ask_quantity: 20, bid_price: nil, bid_quantity: nil}
    ]
  """
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
