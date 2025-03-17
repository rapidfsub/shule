alias Emil.Action.ManualActionInputValidationTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.ManualCreate do
  use Ash.Resource.ManualCreate

  @impl Ash.Resource.ManualCreate
  def create(changeset, _opts, _context) do
    %{} = d1 = Changeset.get_attribute(changeset, :d1)
    %{} = _d2 = Changeset.get_argument(changeset, :d2)
    Changeset.for_create(ThisTest.Obj, :create, %{d1: d1}) |> Ash.create()
  end
end

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    create :manual_create do
      accept :*
      argument :d2, :decimal, allow_nil?: false
      manual ThisTest.ManualCreate
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "does not execute manual action if input validation fails" do
    assert {:error, _reason} =
             Changeset.for_create(ThisTest.Obj, :manual_create) |> Ash.create()

    assert {:error, _reason} =
             Changeset.for_create(ThisTest.Obj, :manual_create, %{d2: 1}) |> Ash.create()

    assert {:error, _reason} =
             Changeset.for_create(ThisTest.Obj, :manual_create, %{d1: 1}) |> Ash.create()

    assert Changeset.for_create(ThisTest.Obj, :manual_create, %{d1: 1, d2: 1})
           |> Ash.create!()
  end
end
