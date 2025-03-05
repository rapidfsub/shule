[
  import_deps: [
    :ash,
    :ash_state_machine,
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
