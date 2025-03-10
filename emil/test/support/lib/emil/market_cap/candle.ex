defmodule Emil.MarketCap.Candle do
  use Ash.Resource,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer,
    domain: Emil.MarketCap

  actions do
    defaults [:read, create: :*]
  end

  policies do
    policy action_type(:create) do
      authorize_if expr(^actor(:name) == "admin")
    end

    policy action_type(:read) do
      authorize_if always()
    end
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
