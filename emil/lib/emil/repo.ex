defmodule Emil.Repo do
  use Ecto.Repo,
    otp_app: :emil,
    adapter: Ecto.Adapters.Postgres
end
