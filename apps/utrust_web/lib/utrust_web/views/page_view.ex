defmodule UtrustWeb.PageView do
  use UtrustWeb, :view

  alias Utrust.Transactions

  def data(conn) do
    %{transactions: transactions(conn)}
  end

  def transactions(conn) do
    html =
      Transactions.get_transactions_groupped()
      |> Enum.reduce("", fn type, acc ->
        acc <> transaction_row(type)
      end)
      |> Floki.parse()
      |> List.wrap()

    {:list, [], html}
  end

  defp transaction_row({title, list}) do
    html_list =
      Enum.map(list, fn transaction ->
        "<dt>#{transaction.txhash}</dt>"
      end)

    ~s|
    <section class="row">
      <article class="column">
        <h2>#{title}</h2>
        <dl>
          #{html_list}
        </dl>
      </article>
    </section>
    |
  end
end
