defmodule Ynabit.Repo.Migrations.ChangeRawTypeToMapInNotifications do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      remove :raw
      add :raw, :map
    end
  end
end
