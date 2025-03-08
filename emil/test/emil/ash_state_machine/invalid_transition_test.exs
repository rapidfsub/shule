alias Emil.AshStateMachine.InvalidTransitionTest, as: ThisTest

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain,
    extensions: [AshStateMachine]

  actions do
    defaults [:read, create: :*]

    update :cancel do
      change transition_state(:canceled)
    end
  end

  attributes do
    uuid_v7_primary_key :id
  end

  state_machine do
    initial_states [:created]
    default_initial_state :created

    transitions do
      transition :cancel, from: :created, to: :canceled
    end
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "returns an error when attempting an invalid transition" do
    assert obj = Ash.Changeset.for_create(ThisTest.Obj, :create) |> Ash.create!()
    assert obj = Ash.Changeset.for_update(obj, :cancel) |> Ash.update!()
    assert {:error, _reason} = Ash.Changeset.for_update(obj, :cancel) |> Ash.update()
  end
end
