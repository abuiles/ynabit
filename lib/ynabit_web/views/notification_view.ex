defmodule YnabitWeb.NotificationView do
  use YnabitWeb, :view
  alias YnabitWeb.NotificationView

  def render("index.json", %{notifications: notifications}) do
    %{data: render_many(notifications, NotificationView, "notification.json")}
  end

  def render("show.json", %{notification: notification}) do
    %{data: render_one(notification, NotificationView, "notification.json")}
  end

  def render("notification.json", %{notification: notification}) do
    %{id: notification.id,
      raw: notification.raw,
      payload: notification.payload,
      processed: notification.processed}
  end
end
