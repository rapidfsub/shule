defmodule Shou.Domain.Obj do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: Shou.Domain

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    read :read_by_name do
      argument :name, :string
      filter expr(contains(name, ^arg(:name)))
      pagination keyset?: true, default_limit: 10, required?: false
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false, public?: true
  end
end
