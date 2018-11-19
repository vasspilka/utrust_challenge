defmodule UtrustWeb.PageView do
  use UtrustWeb, :view

  alias Utrust.Transactions, as: T

  def data(_conn) do
    for {key, transactions} <- T.get_transactions_groupped(), into: %{} do
      html =
        Enum.map(transactions, fn transaction ->
          "<dt>#{transaction.txhash}</dt>"
        end)
        |> Floki.parse()
        |> List.wrap

      {key, {:list, [], html}}
     end
  end
end
