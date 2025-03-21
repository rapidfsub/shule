use Emil.TestPrelude
alias Emil.Changeset.GetAttributeReturnTypeTest, as: ThisTest

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "get_attribute returns a value cast to the declared type" do
    changeset = Changeset.for_create(ThisTest.Obj, :create, %{"d1" => 1.5})
    assert Map.fetch!(changeset.params, "d1") == 1.5

    assert %{} = d1 = Changeset.get_attribute(changeset, :d1)
    assert Decimal.eq?(d1, "1.5")

    changeset = Changeset.for_create(ThisTest.Obj, :create, %{"d1" => "1.5"})
    assert Map.fetch!(changeset.params, "d1") == "1.5"

    assert %{} = d1 = Changeset.get_attribute(changeset, :d1)
    assert Decimal.eq?(d1, "1.5")
  end
end
