defmodule Ynabit.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :slug, :string
      add :account_id, :string
      add :budget_id, :string
      add :api_token, :string

      timestamps()
    end
  end
end
