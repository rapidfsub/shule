alias Emil.Action.StringKeyOverridesAtomKeyInChangesetTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain

  actions do
    create :create do
      accept :*
      argument :s2, :ci_string, allow_nil?: false
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :s1, :ci_string, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "string key overrides atom key" do
    p1 = %{s1: "atom", s2: "atom"}
    changeset = Changeset.for_create(ThisTest.Obj, :create, p1)
    assert Changeset.get_attribute(changeset, :s1) |> to_string() == "atom"
    assert Changeset.get_argument(changeset, :s2) |> to_string() == "atom"

    p2 = %{"s1" => "string", "s2" => "string"}
    changeset = Changeset.for_create(ThisTest.Obj, :create, p2)
    assert Changeset.get_attribute(changeset, :s1) |> to_string() == "string"
    assert Changeset.get_argument(changeset, :s2) |> to_string() == "string"

    params = Map.merge(p1, p2)
    changeset = Changeset.for_create(ThisTest.Obj, :create, params)
    assert Changeset.get_attribute(changeset, :s1) |> to_string() == "string"
    assert Changeset.get_argument(changeset, :s2) |> to_string() == "string"
  end
end
