alias Emil.Change.ManageRelationshipNilTest, as: ThisTest

defmodule ThisTest.Post do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    defaults [:read, create: :*]

    update :append_comment do
      argument :comment, :map
      change manage_relationship(:comment, :comments, type: :create)
    end

    update :append_comments do
      argument :comments, {:array, :map}
      change manage_relationship(:comments, type: :create)
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :content, :string, allow_nil?: false, public?: true
  end

  relationships do
    has_many :comments, ThisTest.Comment
  end
end

defmodule ThisTest.Comment do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :content, :string, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :post, ThisTest.Post
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  setup do
    params = %{content: "post"}
    post = Ash.Changeset.for_create(ThisTest.Post, :create, params) |> Ash.create!()
    %{post: post}
  end

  test "manage_relationship results from passing a map argument", %{post: post} do
    assert post = Ash.Changeset.for_update(post, :append_comment) |> Ash.update!()
    assert %{comments: %Ash.NotLoaded{}} = post

    params = %{comment: nil}
    assert post = Ash.Changeset.for_update(post, :append_comment, params) |> Ash.update!()
    assert %{comments: []} = post

    params = %{comment: %{content: "comment"}}
    assert post = Ash.Changeset.for_update(post, :append_comment, params) |> Ash.update!()
    assert %{comments: [%ThisTest.Comment{}]} = post
  end

  test "manage_relationship results from passing an array of maps argument", %{post: post} do
    assert post = Ash.Changeset.for_update(post, :append_comments) |> Ash.update!()
    assert %{comments: %Ash.NotLoaded{}} = post

    params = %{comments: nil}
    assert post = Ash.Changeset.for_update(post, :append_comments, params) |> Ash.update!()
    assert %{comments: []} = post

    params = %{comments: []}
    assert post = Ash.Changeset.for_update(post, :append_comments, params) |> Ash.update!()
    assert %{comments: []} = post

    params = %{comments: [%{content: "comment"}]}
    assert post = Ash.Changeset.for_update(post, :append_comments, params) |> Ash.update!()
    assert %{comments: [%ThisTest.Comment{}]} = post
  end
end
