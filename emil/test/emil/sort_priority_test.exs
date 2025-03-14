alias Emil.SortPriorityTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Parent do
  use Ash.Resource,
    domain: TestDomain,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, create: :*]

    update :append_action_sort do
      require_atomic? false
      argument :action_sort, :map, allow_nil?: false
      change manage_relationship(:action_sort, :action_sorts, type: :create)
    end

    update :append_prepare_sort do
      require_atomic? false
      argument :prepare_sort, :map, allow_nil?: false
      change manage_relationship(:prepare_sort, :prepare_sorts, type: :create)
    end
  end

  attributes do
    uuid_v7_primary_key :id
  end

  relationships do
    has_many :action_sorts, ThisTest.ActionSort, sort: [d1: :asc]
    has_many :prepare_sorts, ThisTest.PrepareSort, sort: [d1: :asc]
  end
end

defmodule ThisTest.ActionSort do
  use Ash.Resource,
    domain: TestDomain,
    data_layer: Ash.DataLayer.Ets,
    primary_read_warning?: false

  actions do
    defaults create: :*

    read :sorted_read do
      primary? true
      # Using the prepare option in the primary read action is not recommended.
      prepare build(sort: [d1: :desc])
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :parent, ThisTest.Parent
  end
end

defmodule ThisTest.PrepareSort do
  use Ash.Resource,
    domain: TestDomain,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, create: :*]

    read :sorted_read do
      prepare build(sort: [d1: :asc])
    end
  end

  preparations do
    prepare build(sort: [d1: :desc])
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :parent, ThisTest.Parent
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  setup_all do
    parent = Changeset.for_create(ThisTest.Parent, :create) |> Ash.create!()

    for d1 <- 1..3 do
      params = %{action_sort: %{d1: d1}}
      Changeset.for_update(parent, :append_action_sort, params) |> Ash.update!()
    end

    for d1 <- 1..3 do
      params = %{prepare_sort: %{d1: d1}}
      Changeset.for_update(parent, :append_prepare_sort, params) |> Ash.update!()
    end

    %{parent: parent}
  end

  test "read action sort precedes relationship sort", %{parent: parent} do
    parent = Ash.load!(parent, action_sorts: [])
    assert Enum.map(parent.action_sorts, &to_string(&1.d1)) == ["3", "2", "1"]
  end

  test "read action sort precedes query sort" do
    assert Ash.Query.for_read(ThisTest.ActionSort, :sorted_read)
           |> Ash.Query.sort(d1: :asc)
           |> Ash.read!()
           |> Enum.map(&to_string(&1.d1)) == ["3", "2", "1"]

    assert Ash.Query.for_read(ThisTest.ActionSort, :sorted_read)
           |> Ash.Query.sort([d1: :asc], prepend?: true)
           |> Ash.read!()
           |> Enum.map(&to_string(&1.d1)) == ["1", "2", "3"]
  end

  test "global preparation sort precedes relationship sort", %{parent: parent} do
    parent = Ash.load!(parent, prepare_sorts: [])
    assert Enum.map(parent.prepare_sorts, &to_string(&1.d1)) == ["3", "2", "1"]
  end

  test "global preparation sort precedes read action sort" do
    assert Ash.Query.for_read(ThisTest.PrepareSort, :sorted_read)
           |> Ash.read!()
           |> Enum.map(&to_string(&1.d1)) == ["3", "2", "1"]
  end

  test "global preparation sort precedes query" do
    assert Ash.Query.for_read(ThisTest.PrepareSort, :read)
           |> Ash.Query.sort(d1: :asc)
           |> Ash.read!()
           |> Enum.map(&to_string(&1.d1)) == ["3", "2", "1"]

    assert Ash.Query.for_read(ThisTest.PrepareSort, :read)
           |> Ash.Query.sort([d1: :asc], prepend?: true)
           |> Ash.read!()
           |> Enum.map(&to_string(&1.d1)) == ["1", "2", "3"]
  end
end
