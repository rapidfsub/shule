use Emil.TestPrelude
alias Emil.Changeset.ChangingAttributeTest, as: ThisTest

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

  test "changing_attribute? returns true only when the new value differs from the previous one" do
    params = %{s1: "1", d1: 1}
    changeset = Changeset.for_create(ThisTest.Obj, :create, params)
    assert Changeset.changing_attribute?(changeset, :s1)
    assert Changeset.changing_attribute?(changeset, :d1)
    refute Changeset.changing_attribute?(changeset, :s2)
    obj = Changeset.for_create(ThisTest.Obj, :create, params) |> Ash.create!()

    changeset = Changeset.for_update(obj, :update, %{s1: "1"})
    refute Changeset.changing_attribute?(changeset, :s1)
    changeset = Changeset.for_update(obj, :update, %{s1: "2"})
    assert Changeset.changing_attribute?(changeset, :s1)

    changeset = Changeset.for_update(obj, :update, %{d1: 1})
    refute Changeset.changing_attribute?(changeset, :d1)
    changeset = Changeset.for_update(obj, :update, %{d1: "1"})
    refute Changeset.changing_attribute?(changeset, :d1)
    changeset = Changeset.for_update(obj, :update, %{d1: "2"})
    assert Changeset.changing_attribute?(changeset, :d1)
  end
end
