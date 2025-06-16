alias Emil.Relationship.JoinResourceSortTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Post do
  require Ash.Sort

  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    uuid_v7_primary_key :id
  end

  relationships do
    has_many :post_tags, ThisTest.PostTag, sort: [:priority]
    many_to_many :tags, ThisTest.Tag, through: ThisTest.PostTag

    many_to_many :sorted_tags, ThisTest.Tag do
      through ThisTest.PostTag
      sort [Ash.Sort.expr_sort(post_tags.priority)]
    end
  end
end

defmodule ThisTest.Tag do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :name, :ci_string, allow_nil?: false, public?: true
  end

  relationships do
    has_many :post_tags, ThisTest.PostTag
    many_to_many :posts, ThisTest.Post, through: ThisTest.PostTag
  end
end

defmodule ThisTest.PostTag do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :priority, :integer, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :post, ThisTest.Post, allow_nil?: false, public?: true
    belongs_to :tag, ThisTest.Tag, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "can sort many_to_manys using attribute in join resource" do
    params = %{}
    assert post = Changeset.for_create(ThisTest.Post, :create, params) |> Ash.create!()

    for {name, priority} <- [{"tag1", 1}, {"tag3", 3}, {"tag2", 2}] do
      tag_params = %{name: name}
      tag = Changeset.for_create(ThisTest.Tag, :create, tag_params) |> Ash.create!()
      post_tag_params = %{post_id: post.id, tag_id: tag.id, priority: priority}
      Changeset.for_create(ThisTest.PostTag, :create, post_tag_params) |> Ash.create!()
    end

    post = Ash.load!(post, tags: [], sorted_tags: [])
    assert Enum.map(post.tags, &to_string(&1.name)) == ["tag1", "tag3", "tag2"]
    assert Enum.map(post.sorted_tags, &to_string(&1.name)) == ["tag1", "tag2", "tag3"]
  end
end
