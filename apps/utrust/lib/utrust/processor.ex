defmodule Utrust.Transactions.Processor do
  use GenServer

  alias Utrust.Transactions.Repository
  alias Utrust.Transactions.Transaction

  @moduledoc """
  Does all the work for transactions without holding crucial state.
  """

  @doc false
  def process(command) do
    GenServer.cast(__MODULE__, command)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    init_state = %{
      command_history: [],
      events_accident_free: 0
    }

    {:ok, init_state}
  end

  @impl true
  def handle_cast(command, state) do
    case command do
      {:push, txhash }->
        Repository.push(%Transaction{
          txhash: txhash,
          block_height: Etherapi.get_transaction_block_number(txhash),
          received_at: NaiveDateTime.utc_now
        })
      {:confirm, txhash} ->
        %{eth_block_number: block_number} = Utrust.Blockchain.get_state()

        Repository.confirm(txhash)
      _ -> "NOOP"
    end


    new_state = %{
      command_history: [command | state.command_history],
      events_accident_free: state.events_accident_free + 1
    }

    {:noreply, new_state}
  end
end
