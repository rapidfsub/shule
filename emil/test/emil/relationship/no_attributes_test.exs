alias Emil.Relationship.NoAttributesTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Post do
  use Ash.Resource,
    domain: TestDomain,
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
    attribute :content, :string, allow_nil?: false, public?: true
  end

  relationships do
    has_many :comments, ThisTest.Comment

    has_many :replies, ThisTest.Reply do
      no_attributes? true
      filter expr(comment_id == parent(comments.id))
    end
  end
end

defmodule ThisTest.Comment do
  use Ash.Resource,
    domain: TestDomain,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, create: :*]

    update :append_reply do
      require_atomic? false
      argument :reply, :map, allow_nil?: false
      change manage_relationship(:reply, :replies, type: :create)
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :content, :string, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :post, ThisTest.Post, allow_nil?: false
    has_many :replies, ThisTest.Reply
  end
end

defmodule ThisTest.Reply do
  use Ash.Resource,
    domain: TestDomain,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :content, :string, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :comment, ThisTest.Comment, allow_nil?: false

    has_one :post, ThisTest.Post do
      no_attributes? true
      filter expr(id == parent(comment.post_id))
    end
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  setup_all %{} do
    params = %{content: "post"}
    assert post = Changeset.for_create(ThisTest.Post, :create, params) |> Ash.create!()

    params = %{comment: %{content: "comment"}}
    assert post = Changeset.for_update(post, :append_comment, params) |> Ash.update!()
    assert post = Changeset.for_update(post, :append_comment, params) |> Ash.update!()
    assert post = Changeset.for_update(post, :append_comment, params) |> Ash.update!()
    [comment | _] = post.comments

    params = %{reply: %{content: "reply"}}
    assert comment = Changeset.for_update(comment, :append_reply, params) |> Ash.update!()
    assert comment = Changeset.for_update(comment, :append_reply, params) |> Ash.update!()
    [reply | _] = comment.replies

    %{post: post, comment: comment, reply: reply}
  end

  test "Post.replies relationship correctly retrieves related replies", %{post: post} do
    post = Ash.load!(post, replies: [])
    assert length(post.replies) == 2
  end

  test "Reply.post relationship correctly retrieves associated post", %{post: post, reply: reply} do
    reply = Ash.load!(reply, post: [])
    assert post.id == reply.post.id
  end
end
