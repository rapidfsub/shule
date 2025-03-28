use Emil.TestPrelude
alias Emil.Action.DirtyUpdateValidationTest, as: ThisTest

defmodule ThisTest.Obj do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, create: :*, update: :*]

    update :update_positive do
      accept [:d1]
      validate compare(:d2, greater_than: 0)
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, allow_nil?: false, public?: true
    attribute :d2, :decimal, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "can prevent update even if it is stale" do
    obj = Changeset.for_create(ThisTest.Obj, :create, %{d1: 1, d2: 1}) |> Ash.create!()
    old_obj = obj
    obj = Changeset.for_update(obj, :update, %{d1: -1, d2: -1}) |> Ash.update!()

    params = %{d1: 10}
    assert Decimal.eq?(obj.d2, -1)
    assert {:error, _} = Changeset.for_update(obj, :update_positive, params) |> Ash.update()

    assert Decimal.eq?(old_obj.d2, 1)
    assert {:error, _} = Changeset.for_update(old_obj, :update_positive, params) |> Ash.update()
  end
end
