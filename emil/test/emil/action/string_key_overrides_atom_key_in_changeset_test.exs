alias Emil.Action.StringKeyOverridesAtomKeyInChangesetTest, as: ThisTest

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain

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
    changeset = Ash.Changeset.for_create(ThisTest.Obj, :create, p1)
    assert Ash.Changeset.get_attribute(changeset, :s1) |> to_string() == "atom"
    assert Ash.Changeset.get_argument(changeset, :s2) |> to_string() == "atom"

    p2 = %{"s1" => "string", "s2" => "string"}
    changeset = Ash.Changeset.for_create(ThisTest.Obj, :create, p2)
    assert Ash.Changeset.get_attribute(changeset, :s1) |> to_string() == "string"
    assert Ash.Changeset.get_argument(changeset, :s2) |> to_string() == "string"

    params = Map.merge(p1, p2)
    changeset = Ash.Changeset.for_create(ThisTest.Obj, :create, params)
    assert Ash.Changeset.get_attribute(changeset, :s1) |> to_string() == "string"
    assert Ash.Changeset.get_argument(changeset, :s2) |> to_string() == "string"
  end
end
