defmodule Emil.Ash.MissingArgumentValidationTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    create :create
  end

  changes do
    change fn changeset, _context ->
      Ash.Changeset.set_argument(changeset, :hello, "world")
    end
  end

  validations do
    validate argument_equals(:hello, "world")
  end

  attributes do
    uuid_v7_primary_key :id
  end
end

defmodule Emil.Ash.MissingArgumentValidationTest do
  alias __MODULE__.Obj
  use ExUnit.Case, async: true

  test "validation fails when argument is missing" do
    changeset = Ash.Changeset.for_create(Obj, :create, %{})
    refute Ash.Changeset.get_argument(changeset, :hello)
    assert {:error, _error} = Ash.create(changeset)
  end
end
