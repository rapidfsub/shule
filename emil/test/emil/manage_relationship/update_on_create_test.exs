alias Emil.ManageRelationship.UpdateOnCreateTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Deposit do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, create: :*]

    update :add_amount do
      argument :offset, :integer, allow_nil?: false
      change atomic_update(:amount, expr(amount + ^arg(:offset)))
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :amount, :integer, allow_nil?: false, public?: true
  end

  relationships do
    has_many :pays, ThisTest.Pay
  end
end

defmodule ThisTest.Pay do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read]

    create :create do
      primary? true
      accept :*
      argument :deposit_id, :uuid_v7, allow_nil?: false

      change before_action(fn changeset, context ->
               deposit = %{
                 id: Changeset.get_argument(changeset, :deposit_id),
                 offset: -Changeset.get_attribute(changeset, :amount)
               }

               Changeset.manage_relationship(changeset, :deposit, deposit,
                 on_lookup: {:relate_and_update, :add_amount}
               )
             end)
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :amount, :integer, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :deposit, ThisTest.Deposit, allow_nil?: false
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "can update the related resource on create" do
    deposit = Changeset.for_create(ThisTest.Deposit, :create, amount: 10) |> Ash.create!()
    assert 10 = Ash.reload!(deposit).amount

    params = %{deposit_id: deposit.id, amount: 5}
    Changeset.for_create(ThisTest.Pay, :create, params) |> Ash.create!()
    assert 5 = Ash.reload!(deposit).amount
  end
end
