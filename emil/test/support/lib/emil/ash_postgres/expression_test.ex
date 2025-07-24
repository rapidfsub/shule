alias Emil.AshPostgres.ExpressionTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Token do
  use Ash.Resource,
    domain: TestDomain,
    data_layer: AshPostgres.DataLayer

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :expires_at, :utc_datetime, allow_nil?: false, public?: true
  end

  calculations do
    calculate :is_utc_active, :boolean do
      calculation expr(expires_at > lazy({FakeDateTime, :utc_now, []}))
    end

    calculate :is_seoul_active, :boolean do
      calculation expr(expires_at > lazy({FakeDateTime, :seoul_now, []}))
    end
  end

  postgres do
    table "token"
    schema "expression_test"
    repo Emil.TestRepo
  end
end
