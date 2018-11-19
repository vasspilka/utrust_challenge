defmodule UtrustWeb.PageController do
  use UtrustWeb, :controller
  import Texas.Controller

  def index(conn, _params) do
    texas_render(conn, "index.html", texas: UtrustWeb.PageView.data(conn))
  end

  def update(conn, %{"add_transaction" => txhash}) do
    Utrust.Transactions.push_transaction(txhash)
    UtrustWeb.Endpoint.broadcast("texas:diff:transactions", "", %{})
    texas_redirect(conn, to: "/")
  end

  def update(conn, _) do
    texas_redirect(conn, to: "/")
  end
end
