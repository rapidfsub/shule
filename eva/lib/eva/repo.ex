defmodule Eva.Repo do
  use Ecto.Repo,
    otp_app: :eva,
    adapter: Ecto.Adapters.Postgres
end
