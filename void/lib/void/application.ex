defmodule Void.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [Void.Repo, {AshAuthentication.Supervisor, [otp_app: :void]}]

    opts = [strategy: :one_for_one, name: Void.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
