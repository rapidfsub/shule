alias Emil.GlobalChangesFollowLocalChangesTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain

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

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "global changes follow local changes" do
    assert obj = Changeset.for_create(ThisTest.Obj, :create, %{}) |> Ash.create!()
    assert obj.name == "global"
  end
end
