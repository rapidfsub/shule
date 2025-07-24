alias Emil.AshPostgres.ExpressionTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.FakeDateTime do
  def utc_now() do
    ~U[2000-01-02 00:00:00Z]
  end

  def seoul_now() do
    utc_now() |> DateTime.shift_zone!("Asia/Seoul")
  end
end

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
      calculation expr(expires_at > lazy({ThisTest.FakeDateTime, :utc_now, []}))
    end

    calculate :is_seoul_active, :boolean do
      calculation expr(expires_at > lazy({ThisTest.FakeDateTime, :seoul_now, []}))
    end
  end

  postgres do
    table "token"
    schema "expression_test"
    repo Emil.TestRepo
  end
end
