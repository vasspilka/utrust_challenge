defmodule UtrustWeb.PageController do
  use UtrustWeb, :controller
  import Texas.Controller

  def index(conn, _params) do
    texas_render(conn, "index.html", texas: UtrustWeb.PageView.data(conn))
  end

  def update(conn, %{"add_transaction" => txhash}) do
    Utrust.Transactions.push(String.trim(txhash))
    # Follow chain of messages before rerendering
    :sys.get_state(Utrust.Transactions.Processor)
    :sys.get_state(Utrust.Transactions.Repository)
    :sys.get_state(Utrust.Transactions.Processor)
    :sys.get_state(Utrust.Transactions.Repository)
    UtrustWeb.Endpoint.broadcast("texas:diff:transactions", "", %{})
    texas_redirect(conn, to: "/")
  end

  def update(conn, _) do
    texas_redirect(conn, to: "/")
  end
end
