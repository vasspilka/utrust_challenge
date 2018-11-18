defmodule Utrust.Transactions.Repository do
  use GenServer

  @moduledoc """
  Inmemory repository for storing transactions.
  """

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_call(:get_all, _from, transactions) do
    {:reply, transactions, transactions}
  end

  @impl true
  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end
end
