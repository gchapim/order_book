# OrderBook

A simple Exchange OrderBook application written in Elixir using GenServers.

## Requisites

- Elixir 1.11
- OTP (23)

## Running

After cloning the repo, you can start the application running the `iex` inside the project folder:

```
iex -S mix
```

## How to use

### Starting
Every exchange is a running genserver. To get a new exchange you can run `start_link` function:

```elixir
iex(1)> {:ok, exchange_pid} = OrderBook.Exchange.start_link()
```

### Sending an instruction

Then you can send an instruction to that process:

```elixir
iex(2)> OrderBook.Exchange.send_instruction(exchange_pid, %{
... instruction: :new,
... side: :bid,
... price_level_index: 1, 
... price: 50.0,
... quantity: 30
... })
:ok
```

An Instruction needs to match the following type:

```elixir
%{
  instruction: :new | :update | :delete,
  side: :bid | :ask,
  price_level_index: integer(),
  price: float(),
  quantity: integer()
}
```

#### Constraints

- If you send an invalid instruction (missing arguments or invalid types) you'll receive an `Ecto.Changeset` error
- You can send a `:delete` instruction without a price/quantity
- The `:update` instruction prints an error if you try to update an inexistent price level

### Getting the order book

To get the current order book for a given price level depth you can use `OrderBook.Exchange.order_book/2`:

```elixir
iex(3)> OrderBook.Exchange.order_book(exchange_pid, 2)
[
  %{ask_price: nil, ask_quantity: nil, bid_price: 50.0, bid_quantity: 30},
  %{ask_price: nil, ask_quantity: nil, bid_price: nil, bid_quantity: nil}
]
```

And that's it! You can spawn as many Exchange processes as you want and send all the instructions you want.
