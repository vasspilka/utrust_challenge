defmodule Utrust.Transactions.Transaction do
  defstruct [:txhash, :block_height, :received_at, :confirmed_at, confirmed?: false]

  @type t :: %__MODULE__{
          txhash: binary,
          block_height: number,
          received_at: NaiveDateTime.t(),
          confirmed_at: NaiveDateTime.t(),
          confirmed?: boolean
        }

  @doc """
  Returns true if the given transaction has the given txhash.
  """
  @spec is?(t, binary) :: boolean
  def is?(%__MODULE__{txhash: txhash}, txhash), do: true
  def is?(%__MODULE__{}, _), do: false

  @doc """
  Confirms the transaction.
  """
  @spec confirm(t) :: t
  def confirm(%__MODULE__{confirmed?: true} = t), do: t

  def confirm(%__MODULE__{confirmed?: false} = t) do
    %__MODULE__{t | confirmed?: true, confirmed_at: NaiveDateTime.utc_now()}
  end

  @doc """
  Checks if a transaction is confirmed.
  """
  @spec is_confirmed?(t) :: boolean
  def is_confirmed?(%__MODULE__{confirmed?: confirmed}), do: confirmed

  @doc """
  Checks if a transaction is confirmed through Ethereum blockchain height.
  """
  @spec is_confirmed?(t, number) :: boolean
  def is_confirmed?(%__MODULE__{block_height: block_height}, eth_block_num)
      when is_number(block_height) and is_number(eth_block_num) and block_height < eth_block_num do
    eth_block_num - block_height > 2
  end

  def is_confirmed?(%__MODULE__{block_height: block_height}, eth_block_num)
      when is_number(block_height) and is_number(eth_block_num) and block_height > eth_block_num do
    raise "Error: Invalid Transaction"
  end
end
