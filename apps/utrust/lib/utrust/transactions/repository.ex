defmodule Utrust.Transactions.Repository do
  use GenServer

  alias Utrust.Transactions.Transaction

  @moduledoc """
  Inmemory repository for storing transactions.
  For transactions public API you might want to look into Utrust.Transactions
  """

  @doc false
  def push(transaction) do
    GenServer.cast(__MODULE__, {:push, transaction})
  end

  @doc false
  def confirm(txhash) do
    GenServer.cast(__MODULE__, {:confirm, txhash})
  end

  @doc false
  def all() do
    GenServer.call(__MODULE__, :get_all)
  end

  @doc false
  def unconfirmed() do
    GenServer.call(__MODULE__, :unconfirmed)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_cast({:push, new_transaction}, state) do

    {:noreply, [new_transaction | state]}
  end

  @impl true
  def handle_cast({:confirm, txhash}, state) do
    new_state =
      Enum.map(state, fn
        %{txhash: ^txhash} = transaction -> Transaction.confirm(transaction)
        transaction -> transaction
      end)

    {:noreply, new_state}
  end

  @impl true
  def handle_call(:get_all, _from, transactions) do
    {:reply, transactions, transactions}
  end

  @impl true
  def handle_call(:unconfirmed, _from, transactions) do
    {:reply, Enum.filter(transactions, &Transaction.is_confirmed?/1), transactions}
  end
end
