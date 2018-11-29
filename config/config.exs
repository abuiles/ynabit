# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ynabit,
  ecto_repos: [Ynabit.Repo],
  ynab_api_token: System.get_env("YNAB_API_TOKEN"),
  ynab_budget_id: System.get_env("YNAB_BUDGET_ID"),
  ynab_account_id: System.get_env("YNAB_ACCOUNT_ID")

# Configures the endpoint
config :ynabit, YnabitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gqfBBssZjwO8sO3BdnveEXWDMZrdTna7ick4Zi1Ef/F3LjDoU6lm/67yslGXWKI1",
  render_errors: [view: YnabitWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ynabit.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bugsnag, api_key: System.get_env("BUGSNAG_API_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
