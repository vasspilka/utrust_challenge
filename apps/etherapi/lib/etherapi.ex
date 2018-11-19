defmodule Etherapi do
  @moduledoc """
  Documentation for Etherapi.
  """

  # Testing requests for external services in a doctest must definitely be a great idea!!
  # Certainly not a smell! xD

  @doc """
  Gets the current block height of the whole Ethereum blockchain.

  ## Examples
  iex> block_number =  Etherapi.get_block_number()
  iex> block_number > 0
  true
  """
  @spec get_block_number() :: number
  def get_block_number() do
    {:ok, num} = Etherscan.eth_block_number()
    num
  end

  @doc """
  Gets the block number of a transaction through the transaction hash.

  ## Examples
  iex> Etherapi.get_transaction_block_number("0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0")
  4_954_885
  """
  @spec get_transaction_block_number(binary) :: number
  def get_transaction_block_number(txhash) when is_binary(txhash) do
    {:ok, %{blockNumber: block_number}} = Etherscan.eth_get_transaction_by_hash(txhash)
    block_number
  end
end
