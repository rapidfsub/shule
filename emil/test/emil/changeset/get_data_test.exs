alias Emil.Changeset.GetDataTest, as: ThisTest

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :s1, :string, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "get_data returns persisted values, not changes" do
    changeset = Ash.Changeset.for_create(ThisTest.Obj, :create)
    assert Ash.Changeset.get_data(changeset, :s1) == nil
    assert Ash.Changeset.get_data(changeset, :s2) == nil

    changeset = Ash.Changeset.for_create(ThisTest.Obj, :create, %{s1: "create"})
    assert Ash.Changeset.get_data(changeset, :s1) == nil

    obj = Ash.create!(changeset)
    changeset = Ash.Changeset.for_update(obj, :update)
    assert Ash.Changeset.get_data(changeset, :s1) == "create"
    assert Ash.Changeset.get_data(changeset, :s2) == nil

    changeset = Ash.Changeset.for_update(obj, :update, %{s1: nil})
    assert Ash.Changeset.get_data(changeset, :s1) == "create"

    changeset = Ash.Changeset.for_update(obj, :update, %{s1: "update"})
    assert Ash.Changeset.get_data(changeset, :s1) == "create"

    obj = Ash.update!(changeset)
    changeset = Ash.Changeset.for_update(obj, :update)
    assert Ash.Changeset.get_data(changeset, :s1) == "update"
  end
end
