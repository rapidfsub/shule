defmodule Emil.SimpleDomain do
  use Ash.Domain

  resources do
    resource Emil.AshPostgres.AggregateTest.Comment
    resource Emil.AshPostgres.AggregateTest.Post
    resource Emil.AshPostgres.ExpressionTest.Token
  end
end
