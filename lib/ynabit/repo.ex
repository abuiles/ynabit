defmodule Ynabit.Repo do
  use Ecto.Repo,
    otp_app: :ynabit,
    adapter: Ecto.Adapters.Postgres
end
