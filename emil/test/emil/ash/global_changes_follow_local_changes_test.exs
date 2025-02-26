defmodule Emil.Ash.GlobalChangesFollowLocalChangesTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    create :create do
      validate attribute_equals(:name, nil)
      change set_attribute(:name, "local")
      validate attribute_equals(:name, "local")
    end
  end

  changes do
    change set_attribute(:name, "global")
  end

  validations do
    validate attribute_equals(:name, "global")
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :name, :string, allow_nil?: false, public?: true
  end
end

defmodule Emil.Ash.GlobalChangesFollowLocalChangesTest do
  alias __MODULE__.Obj
  use ExUnit.Case, async: true

  test "order of global" do
    assert obj = Ash.Changeset.for_create(Obj, :create, %{}) |> Ash.create!()
    assert obj.name == "global"
  end
end
