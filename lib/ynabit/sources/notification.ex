defmodule Ynabit.Sources.Notification do
  use Ecto.Schema
  import Ecto.Changeset


  schema "notifications" do
    field :payload, :map
    field :processed, :boolean, default: false
    field :raw, :string

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:raw, :payload, :processed])
    |> validate_required([:raw])
  end
end
