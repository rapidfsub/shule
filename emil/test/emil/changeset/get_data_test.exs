alias Emil.Changeset.GetDataTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain

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
    changeset = Changeset.for_create(ThisTest.Obj, :create)
    assert Changeset.get_data(changeset, :s1) == nil
    assert Changeset.get_data(changeset, :s2) == nil

    changeset = Changeset.for_create(ThisTest.Obj, :create, %{s1: "create"})
    assert Changeset.get_data(changeset, :s1) == nil

    obj = Ash.create!(changeset)
    changeset = Changeset.for_update(obj, :update)
    assert Changeset.get_data(changeset, :s1) == "create"
    assert Changeset.get_data(changeset, :s2) == nil

    changeset = Changeset.for_update(obj, :update, %{s1: nil})
    assert Changeset.get_data(changeset, :s1) == "create"

    changeset = Changeset.for_update(obj, :update, %{s1: "update"})
    assert Changeset.get_data(changeset, :s1) == "create"

    obj = Ash.update!(changeset)
    changeset = Changeset.for_update(obj, :update)
    assert Changeset.get_data(changeset, :s1) == "update"
  end
end
