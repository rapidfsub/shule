import Config

config :void, token_signing_secret: "hsh3IzsfQWNisEsdolMxFc7g/3+64ZXa"

config :void, Void.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "void_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
