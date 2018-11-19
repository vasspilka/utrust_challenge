defmodule UtrustWeb.Router do
  use UtrustWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Texas.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UtrustWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/update", PageController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", UtrustWeb do
  #   pipe_through :api
  # end
end
