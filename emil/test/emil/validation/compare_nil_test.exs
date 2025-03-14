alias Emil.Validation.CompareNilTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  validations do
    validate compare(:x, greater_than: 0)
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :x, :decimal, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "compare validation passes when attribute is nil" do
    assert {:error, _error} =
             Changeset.for_create(ThisTest.Obj, :create, %{x: -10}) |> Ash.create()

    assert Changeset.for_create(ThisTest.Obj, :create, %{}) |> Ash.create!()
  end
end
