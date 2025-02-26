defmodule Emil.Ash.ChangesetOmitsUnsetKeysTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    create :create do
      accept :*
      argument :d1, :decimal, allow_nil?: false
      argument :d2, :decimal, allow_nil?: false
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :s1, :ci_string, public?: true
    attribute :s2, :ci_string, public?: true
  end
end

defmodule Emil.Ash.ChangesetOmitsUnsetKeysTest do
  alias __MODULE__.Obj
  use ExUnit.Case, async: true

  test "changeset omits unset keys" do
    assert changeset = Ash.Changeset.for_create(Obj, :create, %{s1: nil, d1: nil})

    assert changeset.attributes.s1 == nil
    refute Map.has_key?(changeset.attributes, :s2)

    assert changeset.arguments.d1 == nil
    refute Map.has_key?(changeset.arguments, :d2)
  end
end
