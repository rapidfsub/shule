alias Emil.Action.CreateActionDataTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :s1, :string, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "create action does not contain stored data" do
    changeset = Changeset.for_create(ThisTest.Obj, :create, %{s1: "string"})
    assert Changeset.get_attribute(changeset, :s1) == "string"
    assert Changeset.get_data(changeset, :s1) == nil
  end
end
