alias Emil.Action.ManualCreateTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.ManualCreate do
  use Ash.Resource.ManualCreate

  @impl Ash.Resource.ManualCreate
  def create(changeset, _opts, _context) do
    s1 = Changeset.get_attribute(changeset, :s1)
    Changeset.for_create(ThisTest.Obj, :create, %{s1: s1}) |> Ash.create()
  end
end

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    create :manual_create do
      change set_attribute(:s1, "hello")
      manual ThisTest.ManualCreate
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :s1, :ci_string, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "manual create action applies defined changes" do
    assert obj = Changeset.for_create(ThisTest.Obj, :manual_create) |> Ash.create!()
    assert to_string(obj.s1) == "hello"
  end
end
