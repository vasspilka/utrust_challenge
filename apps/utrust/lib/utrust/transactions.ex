defmodule Utrust.Transactions do
  alias Utrust.Transactions.Repository
  alias Utrust.Transactions.Transaction

  @doc """
  Pushes a transaction to the store.
  """
  @spec push(binary) :: :ok
  def push(txhash) do
    Utrust.Transactions.Processor.process({:push, txhash})
  end

  @doc """
  Confirms a stored transaction.
  """
  @spec confirm(Transaction.t()) :: :ok
  def confirm(transaction) do
    Utrust.Transactions.Processor.process({:confirm, transaction})
  end

  @doc """
  Gets all transactions.
  """
  def all() do
    :sys.get_state(Repository)
  end

  @doc """
  Gets transactions from the repository.
  Then groups them to confirmed and unconfirmed.
  """
  def get_groupped() do
    all()
    |> Enum.group_by(&Transaction.is_confirmed?/1)
    |> Map.new(fn
      {true, items} -> {:confirmed, items}
      {false, items} -> {:unconfirmed, items}
    end)
    |> Map.put_new(:confirmed, [])
    |> Map.put_new(:unconfirmed, [])
  end
end
