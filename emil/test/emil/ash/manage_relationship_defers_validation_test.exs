defmodule Emil.Ash.ManageRelationshipDefersValidationTest.TodoList do
  alias Emil.Ash.ManageRelationshipDefersValidationTest, as: Test

  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    defaults [:read, create: :*]

    create :create_with_tasks do
      accept :*
      argument :tasks, {:array, :map}
      change manage_relationship(:tasks, type: :create)
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :title, :ci_string, allow_nil?: false, public?: true
  end

  relationships do
    has_many :tasks, Test.Task
  end
end

defmodule Emil.Ash.ManageRelationshipDefersValidationTest.Task do
  alias Emil.Ash.ManageRelationshipDefersValidationTest, as: Test

  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    defaults [:read, create: :*]

    create :create_with_todo_list do
      accept :*
      argument :todo_list, :map
      change manage_relationship(:todo_list, type: :create)
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :title, :ci_string, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :todo_list, Test.TodoList, allow_nil?: false
  end
end

defmodule Emil.Ash.ManageRelationshipDefersValidationTest do
  alias __MODULE__.Task
  alias __MODULE__.TodoList
  require Ash.Changeset
  use ExUnit.Case, async: true

  test "manage_relationship defers has_many validation" do
    params = %{title: "todo list", tasks: [%{}]}
    changeset = Ash.Changeset.for_create(TodoList, :create_with_tasks, params)

    assert Ash.Changeset.is_valid(changeset)
    assert {:error, _error} = Ash.create(changeset)
  end

  test "manage_relationship defers belongs_to validation" do
    params = %{title: "task", todo_list: %{}}
    changeset = Ash.Changeset.for_create(Task, :create_with_todo_list, params)

    assert Ash.Changeset.is_valid(changeset)
    assert {:error, _error} = Ash.create(changeset)
  end
end
