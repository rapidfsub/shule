defmodule Emil.MarketCap.Bot do
  use Ash.Resource,
    domain: Emil.MarketCap,
    data_layer: AshPostgres.DataLayer

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    integer_primary_key :id
    attribute :name, :ci_string, allow_nil?: false, public?: true
  end

  postgres do
    table "bot"
    repo Emil.TestRepo
  end
end
