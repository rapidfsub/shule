alias Emil.Action.ArgumentShouldBeExplicitlyProvidedTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    create :create do
      accept :*
      argument :s2, :ci_string, allow_nil?: false
      change set_attribute(:s1, "in")

      change fn changeset, _context ->
        Changeset.set_argument(changeset, :s2, "in")
      end
    end
  end

  changes do
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :s1, :ci_string, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "argument should be passed explicitly" do
    changeset = Changeset.for_create(ThisTest.Obj, :create)
    assert to_string(changeset.arguments.s2) == "in"
    assert {:error, _error} = Ash.create(changeset)

    changeset = Changeset.for_create(ThisTest.Obj, :create, %{s2: "out"})
    assert to_string(changeset.arguments.s2) == "in"
    assert Ash.create!(changeset)
  end
end
