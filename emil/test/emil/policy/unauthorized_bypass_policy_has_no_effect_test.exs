alias Emil.Policy.UnauthorizedBypassPolicyHasNoEffectTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    authorizers: [Ash.Policy.Authorizer],
    domain: TestDomain

  actions do
    defaults [:read, create: :*]
  end

  policies do
    bypass always() do
      authorize_if expr(^actor(:is_admin))
    end

    policy always() do
      authorize_if expr(^actor(:is_staff))
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "an unauthorized bypass policy has no effect" do
    params = %{d1: 1}
    assert {:error, _} = Changeset.for_create(ThisTest.Obj, :create, params) |> Ash.create()
    opts = [actor: %{is_admin: true, is_staff: false}]
    assert Changeset.for_create(ThisTest.Obj, :create, params, opts) |> Ash.create!()
    opts = [actor: %{is_admin: false, is_staff: true}]
    assert Changeset.for_create(ThisTest.Obj, :create, params, opts) |> Ash.create!()
  end
end
