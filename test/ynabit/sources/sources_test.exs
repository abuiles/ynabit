defmodule Ynabit.SourcesTest do
  use Ynabit.DataCase

  alias Ynabit.Sources

  describe "notifications" do
    alias Ynabit.Sources.Notification

    @valid_attrs %{payload: %{}, processed: true, raw: "some raw"}
    @update_attrs %{payload: %{}, processed: false, raw: "some updated raw"}
    @invalid_attrs %{payload: nil, processed: nil, raw: nil}

    def notification_fixture(attrs \\ %{}) do
      {:ok, notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sources.create_notification()

      notification
    end

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Sources.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Sources.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      assert {:ok, %Notification{} = notification} = Sources.create_notification(@valid_attrs)
      assert notification.payload == %{}
      assert notification.processed == true
      assert notification.raw == "some raw"
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sources.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{} = notification} = Sources.update_notification(notification, @update_attrs)
      assert notification.payload == %{}
      assert notification.processed == false
      assert notification.raw == "some updated raw"
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()
      assert {:error, %Ecto.Changeset{}} = Sources.update_notification(notification, @invalid_attrs)
      assert notification == Sources.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Sources.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Sources.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Sources.change_notification(notification)
    end
  end
end
