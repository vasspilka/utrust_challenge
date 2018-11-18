defmodule Utrust.Transactions.Repository do
  use GenServer

  @moduledoc """
  Inmemory repository for storing transactions.
  For transactions public API you might want to look into Utrust.Transactions
  """

  @doc false
  def push(transaction) do
    GenServer.cast(__MODULE__, {:push, transaction})
  end

  @doc false
  def all() do
    GenServer.call(__MODULE__, :get_all)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
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
  def handle_cast({:push, new_transaction}, state) do
    {:noreply, [new_transaction | state]}
  end
end
