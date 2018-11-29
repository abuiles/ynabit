defmodule YnabitWeb.Router do
  use YnabitWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :inbound_notification do
    plug Plug.Parsers, parsers: [:multipart]
  end

  scope "/", YnabitWeb do
    pipe_through :browser

    get "/", PageController, :index
  end


  scope "/api/v1", YnabitWeb do
    pipe_through :inbound_notification

    post "/notifications/parse", NotificationController, :parse
  end
end
