defmodule Ynabit.Sources do
  @moduledoc """
  The Sources context.
  """

  import Ecto.Query, warn: false
  alias Ynabit.Repo

  alias Ynabit.Sources.Notification
  alias Ynabit.Accounts

  @doc """
  Returns the list of notifications.

  ## Examples

      iex> list_notifications()
      [%Notification{}, ...]

  """
  def list_notifications do
    Repo.all(Notification)
  end

  @doc """
  Gets a single notification.

  Raises `Ecto.NoResultsError` if the Notification does not exist.

  ## Examples

      iex> get_notification!(123)
      %Notification{}

      iex> get_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification!(id), do: Repo.get!(Notification, id)

  @doc """
  Creates a notification.

  ## Examples

      iex> create_notification(%{field: value})
      {:ok, %Notification{}}

      iex> create_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification(attrs \\ %{}) do
    %Notification{}
    |> Notification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Takes a notification email and creates a notification.
  """
  def parse_notification(message \\ %{}) do
    changeset =
      case BanknotToYnab.parse(message["text"]) do
        {:ok, payload} -> %{raw: message, payload: payload, processed: true}
        _ -> %{raw: message, payload: %{}, processed: false}
      end

    %Notification{}
    |> Notification.changeset(changeset)
    |> Repo.insert()
  end

  @doc """
  Updates a notification.

  ## Examples

      iex> update_notification(notification, %{field: new_value})
      {:ok, %Notification{}}

      iex> update_notification(notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification(%Notification{} = notification, attrs) do
    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Notification.

  ## Examples

      iex> delete_notification(notification)
      {:ok, %Notification{}}

      iex> delete_notification(notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification(%Notification{} = notification) do
    Repo.delete(notification)
  end

  @doc """
  Post a new transaction to YNAB
  """
  def post_notification_to_ynab(%Notification{} = notification) do
    with slug when not is_nil(slug) <- get_in(notification.raw, ["bcc", "token"]),
         account when not is_nil(account) <- Accounts.get_account_by_slug(slug) do
      budget_id = account.budget_id
      account_id = account.account_id
      url = "https://api.youneedabudget.com/v1/budgets/#{budget_id}/transactions"

      transaction =
        notification.payload |> normalize_payload |> Map.merge(%{account_id: account_id})

      payload = %{transaction: transaction} |> Jason.encode!()

      HTTPoison.start()

      HTTPoison.post(url, payload, [
        {"Content-Type", "application/json"},
        {"Authorization", "Bearer " <> account.api_token}
      ])
    else
      _ -> raise "Unknown notification" <> notification.id
    end
  end

  @doc """
  Normalize the payee_name field to exclude metadata and set amount in milliunits

  ## Examples

      iex> normalize_payee(%{
               amount: -7409,
               approved: true,
               cleared: "cleared",
               date: "2018-11-28",
               import_id: "F6E2DE772440935C7AA43863ABB10C58",
               payee_name: "UBER   *TRIP-WL2SO"
             })
      %{
        amount: -7409000,
        approved: true,
        cleared: "cleared",
        date: "2018-11-28",
        import_id: "F6E2DE772440935C7AA43863ABB10C58",
        payee_name: "UBER",
        memo: "UBER   *TRIP-WL2SO"
      }
  """
  def normalize_payload(payload) do
    with {:ok, payee} <- find_payee(payload[:payee_name]) do
      Map.merge(payload, %{payee_name: payee, memo: payload[:payee_name]})
    else
      _ -> payload
    end
    |> Map.merge(%{amount: trunc(payload[:amount] * 1000)})
  end

  def find_payee(name) do
    regex = [
      {~r/UBER/, "UBER"},
      {~r/CREPES Y WAFFLES/, "CREPES Y WAFFLES"},
      {~r/PIZZERIA OLIVIA/, "PIZZERIA OLIVIA"},
      {~r/NETFLIX/, "NETFLIX"},
      {~r/Carulla/, "Carulla"},
      {~r/FIRE HOUSE/, "FIRE HOUSE"},
      {~r/Spotify/, "Spotify"},
      {~r/HEROKU/, "Heroku"},
      {~r/AMZN/, "Amazon"},
      {~r/EURO/, "Euro Supermercado"},
      {~r/Airbnb/, "Airbnb"},
      {~r/Lolita/, "De Lololita"},
      {~r/Apple/, "Apple"},
      {~r/ALIMENT LAS0/, "Las Tres"}
    ]

    with {_, payee} <- Enum.find(regex, fn {r, _} -> Regex.match?(r, name) end) do
      {:ok, payee}
    else
      _ -> name
    end
  end
end
