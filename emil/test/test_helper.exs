ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Emil.Repo, :manual)

AshOban.config([Emil.TestDomain],
  engine: Oban.Engines.Basic,
  notifier: Oban.Notifiers.Postgres,
  queues: [default: 10],
  repo: Emil.TestRepo
)
|> Oban.start_link()
