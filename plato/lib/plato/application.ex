defmodule Plato.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlatoWeb.Telemetry,
      Plato.Repo,
      {DNSCluster, query: Application.get_env(:plato, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Plato.PubSub},
      # Start a worker by calling: Plato.Worker.start_link(arg)
      # {Plato.Worker, arg},
      # Start to serve requests, typically the last entry
      PlatoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Plato.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlatoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
