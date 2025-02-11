[
  import_deps: [
    :ash_postgres,
    :ash,
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
