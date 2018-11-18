defmodule Utrust.BlockchainState do
  defstruct [:eth_block_number]

  use GenServer

  @moduledoc """
  Keep the state of the blockchain locally in memory.
  (We only care about the block heigh so thats the only thing we store.)
  """

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  @impl true
  def init(_) do
    state = %__MODULE__{
      eth_block_number: Etherapi.get_block_number()
    }

    Process.send_after(self(), :update_blockchain_state, 1000)

    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:update_blockchain_state, state) do
    new_state = %__MODULE__{
      state
      | eth_block_number: Etherapi.get_block_number()
    }

    Process.send_after(self(), :update_blockchain_state, 1000)

    {:noreply, new_state}
  end
end
