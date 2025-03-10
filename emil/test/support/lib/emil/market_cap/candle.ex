defmodule Emil.MarketCap.Candle do
  use Ash.Resource,
    domain: Emil.MarketCap,
    data_layer: AshPostgres.DataLayer

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    integer_primary_key :id
    attribute :open, :decimal, allow_nil?: false, public?: true
    attribute :high, :decimal, allow_nil?: false, public?: true
    attribute :low, :decimal, allow_nil?: false, public?: true
    attribute :close, :decimal, allow_nil?: false, public?: true
  end

  postgres do
    table "candle"
    repo Emil.TestRepo
  end
end
