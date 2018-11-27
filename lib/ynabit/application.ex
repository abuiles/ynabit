defmodule Ynabit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Ynabit.Repo,
      # Start the endpoint when the application starts
      YnabitWeb.Endpoint
      # Starts a worker by calling: Ynabit.Worker.start_link(arg)
      # {Ynabit.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ynabit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    YnabitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
