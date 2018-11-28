defmodule Ynabit.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :raw, :text
      add :payload, :map
      add :processed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
