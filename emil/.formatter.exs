[
  import_deps: [
    :ash,
    :ash_authentication,
    :ash_oban,
    :ash_postgres,
    :ash_state_machine,
    :oban,
    :mixin,
    # default
    :ecto,
    :ecto_sql,
    :phoenix
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [
    Spark.Formatter,
    # default
    Phoenix.LiveView.HTMLFormatter
  ],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
