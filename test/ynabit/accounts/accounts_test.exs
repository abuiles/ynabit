defmodule Ynabit.AccountsTest do
  use Ynabit.DataCase

  alias Ynabit.Accounts

  describe "accounts" do
    alias Ynabit.Accounts.Account

    @valid_attrs %{account_id: "some account_id", api_token: "some api_token", budget_id: "some budget_id", slug: "some slug"}
    @update_attrs %{account_id: "some updated account_id", api_token: "some updated api_token", budget_id: "some updated budget_id", slug: "some updated slug"}
    @invalid_attrs %{account_id: nil, api_token: nil, budget_id: nil, slug: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.account_id == "some account_id"
      assert account.api_token == "some api_token"
      assert account.budget_id == "some budget_id"
      assert account.slug == "some slug"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.account_id == "some updated account_id"
      assert account.api_token == "some updated api_token"
      assert account.budget_id == "some updated budget_id"
      assert account.slug == "some updated slug"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
