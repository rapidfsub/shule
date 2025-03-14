alias Emil.AshStateMachine.OptionalTransitionTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain,
    extensions: [AshStateMachine]

  actions do
    defaults [:read, create: :*]

    update :cancel do
      argument :cancel_date, :date
      change transition_state(:canceled), where: present(:cancel_date)
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

  test "transition is not required" do
    assert obj = Changeset.for_create(ThisTest.Obj, :create) |> Ash.create!()

    assert obj = Changeset.for_update(obj, :cancel) |> Ash.update!()
    assert obj.state == :created

    params = %{cancel_date: ~D[2000-01-01]}
    assert obj = Changeset.for_update(obj, :cancel, params) |> Ash.update!()
    assert obj.state == :canceled
  end
end
