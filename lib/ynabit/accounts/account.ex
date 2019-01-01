defmodule Ynabit.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset


  schema "accounts" do
    field :account_id, :string
    field :api_token, :string
    field :budget_id, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:slug, :account_id, :budget_id, :api_token])
    |> validate_required([:slug, :account_id, :budget_id, :api_token])
  end
end
