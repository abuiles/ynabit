defmodule YnabitWeb.PageController do
  use YnabitWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
