alias Emil.Change.ManageRelationshipDefersValidationTest, as: ThisTest

defmodule ThisTest.TodoList do
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
    has_many :tasks, ThisTest.Task
  end
end

defmodule ThisTest.Task do
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
    belongs_to :todo_list, ThisTest.TodoList, allow_nil?: false
  end
end

defmodule ThisTest do
  require Ash.Changeset
  use ExUnit.Case, async: true

  test "manage_relationship defers has_many validation" do
    params = %{title: "todo list", tasks: [%{}]}
    changeset = Ash.Changeset.for_create(ThisTest.TodoList, :create_with_tasks, params)

    assert Ash.Changeset.is_valid(changeset)
    assert {:error, _error} = Ash.create(changeset)
  end

  test "manage_relationship defers belongs_to validation" do
    params = %{title: "task", todo_list: %{}}
    changeset = Ash.Changeset.for_create(ThisTest.Task, :create_with_todo_list, params)

    assert Ash.Changeset.is_valid(changeset)
    assert {:error, _error} = Ash.create(changeset)
  end
end
