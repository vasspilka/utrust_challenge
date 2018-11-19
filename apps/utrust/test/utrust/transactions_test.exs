defmodule Utrust.TransactionsTest do
  use ExUnit.Case

  alias Utrust.Transactions

  @txhash "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"

  test "can push a transaction to the repository, then retrieve it" do
    assert :sys.get_state(Utrust.Transactions.Repository) == []

    :ok = Transactions.push_transaction(@txhash)

    # Ensure processes stopped all work.
    :sys.get_state(Utrust.Transactions.Processor)
    [transaction] = :sys.get_state(Utrust.Transactions.Repository)

    assert Transactions.Transaction.is?(transaction, @txhash)
    assert [transaction] == Transactions.get_transactions()
  end

  test "it crushes down and burns when a bad txhash is registered" do
    # assert_raise MatchError, fn ->
    #   Transactions.push_transaction("dealwithit")
    # end
  end
end
