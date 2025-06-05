import Config

config :void, token_signing_secret: "enlcb4EReIIeDnKFa0FMRIqkU/+3BrSq"
config :bcrypt_elixir, log_rounds: 1
config :logger, level: :warning
config :ash, disable_async?: true

config :void, Void.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "void_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
