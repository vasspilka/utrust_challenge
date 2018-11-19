defmodule Utrust.TransactionsTest do
  use ExUnit.Case

  alias Utrust.Transactions

  @txhash "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"

  setup do
    Application.ensure_all_started(:utrust)

    # Reset state
    on_exit(fn ->
      Supervisor.terminate_child(Utrust.Supervisor, Transactions.Repository)
      Supervisor.restart_child(Utrust.Supervisor, Transactions.Repository)
      Supervisor.terminate_child(Utrust.Supervisor, Transactions.Processor)
      Supervisor.restart_child(Utrust.Supervisor, Transactions.Processor)
    end)
  end

  test "can push a transaction to the repository, then retrieve it" do
    assert :sys.get_state(Transactions.Repository) == []

    :ok = Transactions.push(@txhash)

    # Ensure processes stopped work (Until storage).
    :sys.get_state(Transactions.Processor)
    [transaction] = :sys.get_state(Transactions.Repository)

    assert Transactions.Transaction.is?(transaction, @txhash)
  end

  test "check confirmation flow" do
    assert %{command_history: [], events_accident_free: 0} ==
             :sys.get_state(Utrust.Transactions.Processor)

    assert [] == :sys.get_state(Utrust.Transactions.Repository)

    # Follow confirmation flow
    :ok = Transactions.push(@txhash)

    # Quite hacky but it works.. most of the time...
    %{events_accident_free: 1} = :sys.get_state(Transactions.Processor)
    [%{confirmed?: false}] = :sys.get_state(Transactions.Repository)
    %{events_accident_free: 2} = :sys.get_state(Transactions.Processor)
    [%{confirmed?: true}] = :sys.get_state(Transactions.Repository)

    [transaction] = Transactions.all()
    assert Transactions.Transaction.is_confirmed?(transaction)
  end
end
