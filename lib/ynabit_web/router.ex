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

  scope "/", YnabitWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", YnabitWeb do
    pipe_through :api

    resources "/notifications", NotificationController, except: [:new, :edit]
  end
end
