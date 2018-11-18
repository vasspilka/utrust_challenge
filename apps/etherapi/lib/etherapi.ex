defmodule Etherapi do
  @moduledoc """
  Documentation for Etherapi.
  """

  @doc """
  Gets the current block height of the whole Ethereum blockchain.
  """
  @spec get_block_number() :: number
  def get_block_number() do
    {:ok, num} = Etherscan.eth_block_number()
    num
  end

  @doc """
  Gets the block number of a transaction through the transaction hash.
  """
  @spec get_transaction_block_number(binary) :: number
  def get_transaction_block_number(txhash) when is_binary(txhash) do
    {:ok, %{blockNumber: block_number }} = Etherscan.eth_get_transaction_by_hash(txhash)
    block_number
  end
end
