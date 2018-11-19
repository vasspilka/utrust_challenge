defmodule Utrust.TransactionsTest do
  use ExUnit.Case

  alias Utrust.Transactions

  @txhash "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"

  test "can push a transaction to the repository, then retrieve it" do
    :ok = Transactions.push_transaction(@txhash)

    assert [
             %Transactions.Transaction{
               txhash: @txhash,
               block_height: 4_954_885
             }
           ] == Transactions.get_transactions()

    assert %{
             confirmed: [
               %Transactions.Transaction{
                 txhash: @txhash,
                 block_height: 4_954_885
               }
             ],
             unconfirmed: []
           } == Transactions.get_transactions_groupped()
  end
end
