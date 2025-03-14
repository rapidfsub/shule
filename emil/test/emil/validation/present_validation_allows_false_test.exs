alias Emil.Validation.PresentValidationAllowsFalseTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    create :create do
      argument :is_admin, :boolean
      validate present(:is_admin)
    end
  end

  attributes do
    uuid_v7_primary_key :id
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "builtin present validation only checks for nil" do
    assert {:error, _reason} = Changeset.for_create(ThisTest.Obj, :create) |> Ash.create()

    params = %{is_admin: nil}

    assert {:error, _reason} =
             Changeset.for_create(ThisTest.Obj, :create, params) |> Ash.create()

    params = %{is_admin: 1}

    assert {:error, _reason} =
             Changeset.for_create(ThisTest.Obj, :create, params) |> Ash.create()

    params = %{is_admin: false}
    assert Changeset.for_create(ThisTest.Obj, :create, params) |> Ash.create!()

    params = %{is_admin: true}
    assert Changeset.for_create(ThisTest.Obj, :create, params) |> Ash.create!()
  end
end
