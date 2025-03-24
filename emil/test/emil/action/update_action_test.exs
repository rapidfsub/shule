use Emil.TestPrelude
alias Emil.Action.UpdateActionTest, as: ThisTest

defmodule ThisTest.Obj do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, create: :*, update: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :s1, :string, allow_nil?: false, public?: true
    attribute :d1, :decimal, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "update action only changes the specified fields" do
    params = %{s1: "1", d1: 1}
    assert obj = Changeset.for_create(ThisTest.Obj, :create, params) |> Ash.create!()

    assert obj = Changeset.for_update(obj, :update, %{s1: "2"}) |> Ash.update!()
    assert obj.s1 == "2"
    assert Decimal.eq?(obj.d1, 1)

    assert obj = Changeset.for_update(obj, :update, %{d1: "2"}) |> Ash.update!()
    assert obj.s1 == "2"
    assert Decimal.eq?(obj.d1, 2)

    params = %{s1: "3", d1: nil}
    assert {:error, _reason} = Changeset.for_update(obj, :update, params) |> Ash.update()
  end
end
