alias Emil.Changeset.CastedAttributesTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain

  actions do
    create :create do
      accept [:s1]
      change set_attribute(:s2, "s2")
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :s1, :string, allow_nil?: false, public?: true
    attribute :s2, :string, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "casted_attributes map includes only explicitly accepted attributes" do
    changeset = Changeset.for_create(ThisTest.Obj, :create)
    assert changeset.attributes == %{s2: "s2"}
    assert changeset.casted_attributes == %{}

    changeset = Changeset.for_create(ThisTest.Obj, :create, %{s1: nil})
    assert changeset.attributes == %{s1: nil, s2: "s2"}
    assert changeset.casted_attributes == %{s1: nil}

    changeset = Changeset.for_create(ThisTest.Obj, :create, %{s1: "s1"})
    assert changeset.attributes == %{s1: "s1", s2: "s2"}
    assert changeset.casted_attributes == %{s1: "s1"}
  end
end
