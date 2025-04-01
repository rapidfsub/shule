use Emil.TestPrelude
alias Emil.ManageRelationship.BelongsToTest, as: ThisTest

defmodule ThisTest.Obj do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, update: :*]

    create :create do
      primary? true
      accept :*

      change fn changeset, _context ->
        Changeset.manage_relationship(changeset, :account, %{balance: 0}, type: :create)
      end
    end

    update :increase_balance do
      require_atomic? false
      argument :account, :term

      change manage_relationship(:account,
               on_match: {:update, :increase_balance},
               on_no_match: :error
             )
    end
  end

  attributes do
    uuid_v7_primary_key :id
  end

  relationships do
    belongs_to :account, ThisTest.Account, allow_nil?: false
  end
end

defmodule ThisTest.Account do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, create: :*, update: :*]

    update :increase_balance do
      change atomic_update(:balance, expr(balance + 1))
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :balance, :decimal, allow_nil?: false, public?: true
  end

  relationships do
    has_one :obj, ThisTest.Obj
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  setup do
    obj = Changeset.for_create(ThisTest.Obj, :create) |> Ash.create!()
    %{obj: obj}
  end

  test "does not update when no account is provided", %{obj: obj} do
    assert obj = Changeset.for_update(obj, :increase_balance) |> Ash.update!()
    assert Decimal.eq?(obj.account.balance, 0)
  end

  test "does not update when given nil", %{obj: obj} do
    params = %{account: nil}
    assert obj = Changeset.for_update(obj, :increase_balance, params) |> Ash.update!()
    assert Decimal.eq?(obj.account.balance, 0)
  end

  test "updates account when given primary key", %{obj: obj} do
    params = %{account: obj.account_id}
    assert obj = Changeset.for_update(obj, :increase_balance, params) |> Ash.update!()
    assert Decimal.eq?(obj.account.balance, 1)
  end

  test "updates account when given map with primary key", %{obj: obj} do
    params = %{account: %{id: obj.account_id}}
    assert obj = Changeset.for_update(obj, :increase_balance, params) |> Ash.update!()
    assert Decimal.eq?(obj.account.balance, 1)
  end

  test "fails when given empty map, despite existing foreign key", %{obj: obj} do
    params = %{account: %{}}
    assert {:error, _} = Changeset.for_update(obj, :increase_balance, params) |> Ash.update()
  end
end
