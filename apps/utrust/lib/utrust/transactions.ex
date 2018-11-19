defmodule Utrust.Transactions do
  alias Utrust.Transactions.Repository
  alias Utrust.Transactions.Transaction

  @doc """
  Pushes a transaction to the store.
  """
  def push_transaction(txhash) do
    Utrust.Transactions.Processor.process({:push, txhash})
  end

  @doc """
  Confirms a stored transaction.
  """
  def confirm_transaction(txhash) do
    Utrust.Transactions.Processor.process({:confirm, txhash})
  end

  @doc """
  Gets all transactions.
  """
  def get_transactions() do
    Repository.all()
  end

  @doc """
  Gets transactions from the repository.
  Then groups them to confirmed and unconfirmed.
  """
  def get_transactions_groupped() do
    Repository.all()
    |> Enum.group_by(&Transaction.is_confirmed?/1)
    |> Map.new(fn
      {true, items} -> {:confirmed, items}
      {false, items} -> {:unconfirmed, items}
    end)
    |> Map.put_new(:confirmed, [])
    |> Map.put_new(:unconfirmed, [])
  end
end
