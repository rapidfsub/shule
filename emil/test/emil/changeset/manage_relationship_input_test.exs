alias Emil.Changeset.ManageRelationshipInputTest, as: ThisTest

defmodule ThisTest.Post do
  use Ash.Resource,
    domain: Emil.TestDomain

  actions do
    defaults [:read, create: :*]

    update :append_comment do
      argument :comment, :map

      change fn changeset, _context ->
               comment = Ash.Changeset.get_argument(changeset, :comment)
               Ash.Changeset.manage_relationship(changeset, :comments, comment, type: :create)
             end,
             where: present(:comment)
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

  test "manage_relationship correctly handles a single map input" do
    params = %{content: "post"}
    assert post = Ash.Changeset.for_create(ThisTest.Post, :create, params) |> Ash.create!()

    params = %{comment: %{content: "comment"}}
    assert post = Ash.Changeset.for_update(post, :append_comment, params) |> Ash.update!()

    assert %{comments: [%{}]} = post
  end
end
