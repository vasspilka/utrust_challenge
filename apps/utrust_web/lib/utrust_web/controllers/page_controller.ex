defmodule UtrustWeb.PageController do
  use UtrustWeb, :controller
  import Texas.Controller

  def index(conn, _params) do
    texas_render(conn, "index.html", texas: UtrustWeb.PageView.data(conn))
  end
end
