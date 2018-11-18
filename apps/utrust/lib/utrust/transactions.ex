defmodule Utrust.Transactions do
  alias Utrust.Transactions.Repository
  alias Utrust.Transactions.Transaction

  @doc """
  Pushes a transaction to the store.
  """
  def push_transaction(txhash) do
    %Transaction{
      txhash: txhash,
      block_height: Etherapi.get_transaction_block_number(txhash)
    }
    |> Repository.push()
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
    %{eth_block_number: block_number} = Utrust.Blockchain.get_state()

    Repository.all()
    |> Enum.group_by(&Transaction.is_confirmed?(&1, block_number))
    |> Map.new(fn
      {true, items} -> {:confirmed, items}
      {false, items} -> {:unconfirmed, items}
    end)
    |> Map.put_new(:confirmed, [])
    |> Map.put_new(:unconfirmed, [])
  end
end
