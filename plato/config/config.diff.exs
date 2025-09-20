import Config

# Ash configuration
config :plato, ash_domains: [Plato.Domain]

# Ash Postgres configuration
config :ash,
  validate_domain_config_inclusion?: false,
  missed_notifications: :ignore
