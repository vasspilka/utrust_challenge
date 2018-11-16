defmodule Utrust.Transaction do
  defstruct [:txhash, :block_num]

  @type t :: %__MODULE__{
          txhash: binary,
          block_num: nil | number
        }

  @doc """
  Checks if a transaction is confirmed.
  """
  @spec is_confirmed?(t, number) :: boolean
  def is_confirmed?(%__MODULE__{block_num: block_num}, eth_block_num)
      when is_number(block_num) and is_number(eth_block_num) and block_num < eth_block_num do
    eth_block_num - block_num > 2
  end

  def is_confirmed?(%__MODULE__{block_num: block_num}, eth_block_num)
      when is_number(block_num) and is_number(eth_block_num) and block_num > eth_block_num do
    raise "Error: Invalid Transaction"
  end
end
