alias Emil.AshPostgres.AggregateTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest do
  use Emil.TestDataCase, async?: true

  test "can load aggregates" do
    post = Changeset.for_create(ThisTest.Post, :create) |> Ash.create!()
    params = %{comment: %{content: "valid"}}

    post =
      for _ <- 1..3, reduce: post do
        post ->
          Changeset.for_update(post, :append_comment, params) |> Ash.update!()
      end

    assert Ash.load!(post, [:has_valid_comments, :has_invalid_comments])
  end
end
