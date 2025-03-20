import Config

config :emil,
  ash_domains: [Emil.Accounts],
  ash_oban_domains: [Emil.Accounts]

config :emil, Oban,
  engine: Oban.Engines.Basic,
  notifier: Oban.Notifiers.Postgres,
  queues: [default: 10],
  repo: Emil.Repo

config :ash,
  allow_forbidden_field_for_relationships_by_default?: true,
  default_page_type: :keyset,
  include_embedded_source_by_default?: false,
  keep_read_action_loads_when_loading?: false,
  policies: [no_filter_static_forbidden_reads?: false],
  show_keysets_for_all_actions?: false

config :spark,
  formatter: [
    remove_parens?: true,
    "Ash.Resource": [
      section_order: [
        :resource,
        :code_interface,
        :actions,
        :policies,
        :pub_sub,
        :preparations,
        :changes,
        :validations,
        :multitenancy,
        :attributes,
        :relationships,
        :calculations,
        :aggregates,
        :identities,
        :postgres,
        :state_machine,
        :authentication,
        :tokens,
        :oban
      ]
    ],
    "Ash.Domain": [section_order: [:resources, :policies, :authorization, :domain, :execution]]
  ]
