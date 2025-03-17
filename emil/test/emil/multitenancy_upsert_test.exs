alias Emil.MultitenancyUpsertTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Company do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_v7_primary_key :id
  end

  relationships do
    has_many :starffs, ThisTest.Staff
  end
end

defmodule ThisTest.Staff do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read]

    create :create do
      primary? true
      upsert? true
      accept :*
      upsert_identity :uniq_name
    end
  end

  multitenancy do
    strategy :attribute
    attribute :company_id
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :name, :ci_string, allow_nil?: false, public?: true
    attribute :age, :integer, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :company, ThisTest.Company, allow_nil?: false
  end

  identities do
    identity :uniq_name, [:name], pre_check_with: TestDomain
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "upsert works correctly with multitenancy" do
    company = Changeset.for_create(ThisTest.Company, :create) |> Ash.create!()
    opts = [tenant: company.id]

    assert staff1 =
             Changeset.for_create(ThisTest.Staff, :create, %{name: "name", age: 10}, opts)
             |> Ash.create!()

    assert staff1.age == 10

    assert staff2 =
             Changeset.for_create(ThisTest.Staff, :create, %{name: "name", age: 20}, opts)
             |> Ash.create!()

    assert staff1.id == staff2.id
    assert staff2.age == 20
  end
end
