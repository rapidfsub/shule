alias Emil.Validation.MissingArgumentValidationTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain

  actions do
    create :create
  end

  changes do
    change fn changeset, _context ->
      Changeset.set_argument(changeset, :hello, "world")
    end
  end

  validations do
    validate argument_equals(:hello, "world")
  end

  attributes do
    uuid_v7_primary_key :id
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "validation fails when argument is missing" do
    changeset = Changeset.for_create(ThisTest.Obj, :create, %{})
    refute Changeset.get_argument(changeset, :hello)
    assert {:error, _error} = Ash.create(changeset)
  end
end
