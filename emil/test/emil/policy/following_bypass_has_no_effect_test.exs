alias Emil.Policy.FollowingBypassHasNoEffectTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, create: :*]
  end

  policies do
    policy always() do
      authorize_if never()
    end

    bypass always() do
      authorize_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "following bypass has no effect" do
    assert {:error, _} = Changeset.for_create(ThisTest.Obj, :create) |> Ash.create()
  end
end
