alias Emil.Calculation.NilPropagationTest, as: ThisTest

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, public?: true
    attribute :d2, :decimal, public?: true
  end

  calculations do
    calculate :sum, :decimal, expr(d1 + d2)
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "calculation returns nil if any operand is nil" do
    obj = Ash.Changeset.for_create(ThisTest.Obj, :create, %{d1: 1, d2: 2}) |> Ash.create!()
    assert Ash.load!(obj, [:sum]).sum |> to_string() == "3"
    obj = Ash.Changeset.for_create(ThisTest.Obj, :create, %{d1: 1}) |> Ash.create!()
    assert Ash.load!(obj, [:sum]).sum == nil
  end
end
