defmodule Utrust.Transactions.Transaction do
  defstruct [:txhash, :block_height]

  @type t :: %__MODULE__{
          txhash: binary,
          block_height: number
        }

  @doc """
  Checks if a transaction is confirmed.
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
