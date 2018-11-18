defmodule Utrust.Transactions.Repository do
  use GenServer

  alias Utrust.Transaction

  @moduledoc """
  Inmemory repository for storing transactions.
  """

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def push_transaction(txhash) do
    GenServer.cast(__MODULE__, {:push, txhash})
  end

  def get_transactions() do
    GenServer.call(__MODULE__, :get_all)
  end

  def get_transactions(:groupped) do
    %{eth_block_number: block_number} = Utrust.BlockchainState.get_state()

    GenServer.call(__MODULE__, :get_all)
    |> Enum.group_by(&Transaction.is_confirmed?(&1, block_number))
    |> Map.new(fn
      {true, items} -> {:confirmed, items}
      {false, items} -> {:unconfirmed, items}
    end)

  end

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_call(:get_all, _from, transactions) do
    {:reply, transactions, transactions}
  end

  @impl true
  def handle_cast({:push, txhash}, state) do
    new_transaction = %Transaction{
      txhash: txhash,
      block_height: Etherapi.get_transaction_block_number(txhash)
    }

    {:noreply, [new_transaction | state]}
  end
end
