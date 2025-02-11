defmodule Victor.Repo do
  use Ecto.Repo,
    otp_app: :victor,
    adapter: Ecto.Adapters.Postgres
end
