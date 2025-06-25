defmodule Shou.Repo do
  use Ecto.Repo,
    otp_app: :shou,
    adapter: Ecto.Adapters.Postgres
end
