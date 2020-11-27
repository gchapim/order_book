defmodule OrderBook.Exchange do
  @moduledoc """
  Exchange implementation
  """

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end
end
