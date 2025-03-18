alias Emil.Policy.ExprPolicyChecksStoredDataTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, create: :*, update: :*]

    create :broken_create do
      accept :*
    end
  end

  policies do
    policy action(:broken_create) do
      authorize_if expr(d1 > 0)
    end

    policy action_type(:update) do
      authorize_if expr(d1 > 0)
    end

    policy action_type([:create, :read]) do
      authorize_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  alias Ash.Changeset
  use ExUnit.Case, async: true

  test "create action policy cannot reference attribute" do
    params = %{d1: -1}
    assert Changeset.for_create(ThisTest.Obj, :create, params) |> Ash.create!()

    assert_raise Ash.Error.Forbidden, fn ->
      Changeset.for_create(ThisTest.Obj, :broken_create, params) |> Ash.create()
    end
  end

  @neg_params %{d1: -1}
  @pos_params %{d1: 1}
  test "expr policy evaluates stored data" do
    neg = Changeset.for_create(ThisTest.Obj, :create, @neg_params) |> Ash.create!()
    assert {:error, _reason} = Changeset.for_update(neg, :update, @pos_params) |> Ash.update()

    pos = Changeset.for_create(ThisTest.Obj, :create, @pos_params) |> Ash.create!()
    assert Changeset.for_update(pos, :update, @neg_params) |> Ash.update!()
  end
end
