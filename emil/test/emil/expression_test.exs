alias Emil.ExpressionTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.DateTime do
  def utc_now() do
    ~U[2000-01-01 00:00:00Z]
  end

  def seoul_now() do
    DateTime.shift_zone!(utc_now(), "Asia/Seoul")
  end
end

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, create: :*]
  end

  preparations do
    prepare build(load: [:is_utc_active, :is_seoul_active])
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :expires_at, :utc_datetime, allow_nil?: false, public?: true
  end

  calculations do
    calculate :is_utc_active, :boolean do
      calculation expr(expires_at > lazy({ThisTest.DateTime, :utc_now, []}))
    end

    calculate :is_seoul_active, :boolean do
      calculation expr(expires_at > lazy({ThisTest.DateTime, :seoul_now, []}))
    end
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "hey" do
    params = %{expires_at: ~U[2000-01-01 00:15:00Z]}

    obj =
      Changeset.for_create(ThisTest.Obj, :create, params)
      |> Ash.create!()
      |> Ash.load!([:is_utc_active, :is_seoul_active])

    assert true = obj.is_utc_active
    assert true = obj.is_seoul_active
  end
end
