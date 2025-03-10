import Config

config :emil, Emil.TestRepo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "emil_test_alt#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :emil,
  ash_domains: [
    Emil.Accounts,
    Emil.MarketCap,
    Emil.TestDomain
  ],
  ecto_repos: [Emil.Repo, Emil.TestRepo],
  token_signing_secret: "e4Afk2zeUOWUmKNvjGnCE+KQDsaRMAvs"

config :emil, Oban, testing: :manual

config :ash,
  disable_async?: true,
  validate_domain_config_inclusion?: false,
  validate_domain_resource_inclusion?: false
