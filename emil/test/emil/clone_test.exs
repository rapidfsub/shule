alias Emil.CloneTest, as: ThisTest

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    defaults [:read, create: :*]

    create :clone do
      accept [:d1]
    end

    create :easy_clone do
      accept [:d1]
      skip_unknown_inputs :*
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, allow_nil?: false, public?: true
    timestamps()
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "can easily clone an object using skip_unknown_inputs option" do
    assert obj1 = Ash.Changeset.for_create(ThisTest.Obj, :create, %{d1: 0.1}) |> Ash.create!()

    # struct is not enumerable
    assert_raise Ash.Error.Unknown, fn ->
      Ash.Changeset.for_create(ThisTest.Obj, :clone, obj1) |> Ash.create()
    end

    params = Map.from_struct(obj1)

    # id should be removed
    assert_raise Ash.Error.Invalid, fn ->
      Ash.Changeset.for_create(ThisTest.Obj, :clone, params) |> Ash.create!()
    end

    assert obj2 = Ash.Changeset.for_create(ThisTest.Obj, :easy_clone, params) |> Ash.create!()
    assert obj1.id != obj2.id
  end
end
