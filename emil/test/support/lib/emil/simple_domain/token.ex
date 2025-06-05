defmodule Emil.SimpleDomain.TokenDateTime do
  def utc_now() do
    ~U[2000-01-02 00:00:00Z]
  end

  def seoul_now() do
    DateTime.shift_zone!(utc_now(), "Asia/Seoul")
  end
end

defmodule Emil.SimpleDomain.Token do
  use Ash.Resource,
    domain: Emil.SimpleDomain,
    data_layer: AshPostgres.DataLayer

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
      calculation expr(expires_at > lazy({Emil.SimpleDomain.TokenDateTime, :utc_now, []}))
    end

    calculate :is_seoul_active, :boolean do
      calculation expr(expires_at > lazy({Emil.SimpleDomain.TokenDateTime, :seoul_now, []}))
    end
  end

  postgres do
    table "token"
    repo Emil.TestRepo
  end
end
