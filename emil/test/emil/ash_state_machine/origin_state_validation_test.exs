alias Emil.AshStateMachine.OriginStateValidationTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain,
    extensions: [AshStateMachine]

  actions do
    defaults [:read, create: :*]

    update :flawed_cancel do
      argument :is_admin, :boolean, allow_nil?: false
      change transition_state(:canceled), where: argument_equals(:is_admin, true)
    end

    update :cancel do
      argument :is_admin, :boolean, allow_nil?: false
      validate argument_equals(:is_admin, true)
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
      transition :flawed_cancel, from: :created, to: :canceled
      transition :cancel, from: :created, to: :canceled
    end
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "origin state is not checked when transition_state change is not executed" do
    obj = Changeset.for_create(ThisTest.Obj, :create) |> Ash.create!()
    params = %{is_admin: true}
    assert obj = Changeset.for_update(obj, :flawed_cancel, params) |> Ash.update!()
    assert obj.state == :canceled

    params = %{is_admin: false}
    assert Changeset.for_update(obj, :flawed_cancel, params) |> Ash.update!()
    assert {:error, _} = Changeset.for_update(obj, :cancel, params) |> Ash.update()
  end
end
