alias Emil.AshPostgres.AggregateTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.Post do
  use Ash.Resource,
    domain: Emil.SimpleDomain,
    data_layer: AshPostgres.DataLayer

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
    has_many :comments, ThisTest.Comment
  end

  aggregates do
    exists :has_valid_comments, :comments do
      filter expr(content == "valid")
    end

    exists :has_invalid_comments, :comments do
      filter expr(content == "invalid")
    end
  end

  postgres do
    table "post"
    schema "aggregate_test"
    repo Emil.TestRepo
  end
end

defmodule ThisTest.Comment do
  use Ash.Resource,
    domain: Emil.SimpleDomain,
    data_layer: AshPostgres.DataLayer

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :content, :string, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :post, ThisTest.Post, allow_nil?: false
  end

  postgres do
    table "comment"
    schema "aggregate_test"
    repo Emil.TestRepo
  end
end
