defmodule Emil.TestDomain do
  use Ash.Domain

  resources do
    allow_unregistered? true

    resource Emil.AshPostgres.AggregateTest.Comment
    resource Emil.AshPostgres.AggregateTest.Post
    resource Emil.AshPostgres.ExpressionTest.Token
  end
end
