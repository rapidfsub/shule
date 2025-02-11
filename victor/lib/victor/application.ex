defmodule Victor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VictorWeb.Telemetry,
      Victor.Repo,
      {DNSCluster, query: Application.get_env(:victor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Victor.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Victor.Finch},
      # Start a worker by calling: Victor.Worker.start_link(arg)
      # {Victor.Worker, arg},
      # Start to serve requests, typically the last entry
      VictorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Victor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VictorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
