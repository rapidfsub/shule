import Config

config :emil,
  ash_domains: [Emil.Accounts],
  token_signing_secret: "e4Afk2zeUOWUmKNvjGnCE+KQDsaRMAvs"

config :emil, Oban, testing: :manual

config :ash,
  disable_async?: true,
  validate_domain_config_inclusion?: false,
  validate_domain_resource_inclusion?: false
