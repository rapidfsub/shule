use Emil.TestPrelude

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Emil.Repo, :manual)

Emil.TestRepo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(Emil.TestRepo, :manual)

AshOban.config([TestDomain],
  engine: Oban.Engines.Basic,
  notifier: Oban.Notifiers.Postgres,
  queues: [default: 10],
  repo: Emil.TestRepo
)
|> Oban.start_link()
