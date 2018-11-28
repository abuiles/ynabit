defmodule YnabitWeb.NotificationController do
  use YnabitWeb, :controller

  alias Ynabit.Sources
  alias Ynabit.Sources.Notification

  action_fallback YnabitWeb.FallbackController

  def parse(conn, _params) do
    # with {:ok, %Notification{} = notification} <- Sources.parse_notification(notification_params) do
    send_resp(conn, :no_content, "")
    # end
  end
end
