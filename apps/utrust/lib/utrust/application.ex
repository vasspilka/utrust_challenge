defmodule Utrust.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  alias Utrust.Transactions.Repository
  alias Utrust.Blockchain

  use Application

  def start(_type, _args) do
    children = [
      Repository,
      Blockchain
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Utrust.Supervisor)
  end
end
