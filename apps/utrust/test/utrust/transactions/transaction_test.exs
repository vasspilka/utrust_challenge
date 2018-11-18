defmodule Utrust.Transactions.TransactionTest do
  use ExUnit.Case

  alias Utrust.Transactions.Transaction

  test "correctly detects a confirmed transaction" do
    transaction = %Transaction{
      txhash: "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0",
      block_height: 4_954_885
    }

    assert Transaction.is_confirmed?(transaction, 4_954_985)
    refute Transaction.is_confirmed?(transaction, 4_954_886)

    assert_raise RuntimeError, fn ->
      Transaction.is_confirmed?(transaction, 1)
    end
  end
end
