use Emil.TestPrelude
alias Emil.Validation.CreateActionsCannotUseAtomicValidationsTest, as: ThisTest

defmodule ThisTest.Validation do
  use Ash.Resource.Validation

  @impl Ash.Resource.Validation
  def atomic(_changeset, _opts, _context) do
    {:atomic, [:d1, :d2], expr(d1 + d2 < 10), "invalid"}
  end
end

defmodule ThisTest.Obj do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, create: :*]
  end

  validations do
    validate ThisTest.Validation
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, allow_nil?: false, public?: true
    attribute :d2, :decimal, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "create actions cannot use atomic validations" do
    changeset = Changeset.for_create(ThisTest.Obj, :create, %{d1: 10, d2: 10})
    assert {:error, %Ash.Error.Framework{}} = Ash.create(changeset)
  end
end
