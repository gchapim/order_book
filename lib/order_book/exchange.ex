defmodule OrderBook.Exchange do
  @moduledoc """
  Exchange implementation
  """

  alias OrderBook.Exchange.{Fetcher, InstructionHandler}
  alias OrderBook.Instruction

  use GenServer

  @type stack :: %{ask: map(), bid: map()}
  @type level_order_book :: [
          %{
            ask_price: float() | nil,
            ask_quantity: number() | nil,
            bid_price: float() | nil,
            bid_quantity: number() | nil
          }
        ]

  @spec start_link(any()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_ \\ nil) do
    GenServer.start_link(__MODULE__, %{ask: %{}, bid: %{}})
  end

  @spec order_book(pid, number()) :: level_order_book()
  def order_book(pid, price_level) do
    GenServer.call(pid, {:order_book, price_level})
  end

  @spec send_instruction(pid, map()) :: :ok | {:error, Ecto.Changeset.t()}
  def send_instruction(pid, instruction) do
    with {:ok, %Instruction{} = instruction} <- Instruction.build(instruction) do
      GenServer.cast(pid, {:send_instruction, instruction})
    end
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:order_book, price_level}, _, stack) do
    {:reply, Fetcher.fetch(stack, price_level), stack}
  end

  @impl true
  def handle_cast({:send_instruction, instruction}, stack) do
    instruction
    |> InstructionHandler.handle(stack)
    |> do_handle_cast(stack)
  end

  defp do_handle_cast({:error, _} = error, old_stack) do
    # We could send it to the caller if it was ready to receive it
    IO.puts(inspect(error))

    {:noreply, old_stack}
  end

  defp do_handle_cast(new_stack, _) do
    {:noreply, new_stack}
  end
end
