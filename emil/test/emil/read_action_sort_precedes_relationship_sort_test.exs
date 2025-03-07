alias Emil.ReadActionSortPrecedesRelationshipSortTest, as: ThisTest

defmodule ThisTest.Post do
  use Ash.Resource,
    domain: Emil.TestDomain,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, create: :*]

    update :append_comment do
      require_atomic? false
      argument :comment, :map, allow_nil?: false
      change manage_relationship(:comment, :comments, type: :create)
    end
  end

  attributes do
    uuid_v7_primary_key :id
  end

  relationships do
    has_many :comments, ThisTest.Comment, sort: [d1: :asc]
  end
end

defmodule ThisTest.Comment do
  use Ash.Resource,
    domain: Emil.TestDomain,
    data_layer: Ash.DataLayer.Ets,
    primary_read_warning?: false

  actions do
    defaults create: :*

    read :read do
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
    belongs_to :post, ThisTest.Post
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "read action sort precedes relationship sort" do
    post = Ash.Changeset.for_create(ThisTest.Post, :create) |> Ash.create!()

    for d1 <- 1..3 do
      Ash.Changeset.for_update(post, :append_comment, %{comment: %{d1: d1}}) |> Ash.update!()
    end

    post = Ash.load!(post, comments: [])
    assert Enum.map(post.comments, &to_string(&1.d1)) == ["3", "2", "1"]
  end
end
