defmodule YnabitWeb.PageControllerTest do
  use YnabitWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "YNABIT"
  end
end
