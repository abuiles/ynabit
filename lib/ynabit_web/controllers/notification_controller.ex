defmodule YnabitWeb.NotificationController do
  use YnabitWeb, :controller

  alias Ynabit.Sources
  alias Ynabit.Sources.Notification

  action_fallback YnabitWeb.FallbackController

  def parse(conn, params) do
    with {:ok, notification = %Notification{}} <- Sources.parse_notification(params) do
      Sources.post_notification_to_ynab(notification)
      send_resp(conn, :no_content, "")
    end
  end
end
