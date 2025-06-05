alias Emil.ExpressionTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest do
  use Emil.TestDataCase, async?: true

  test "should be equal even if the time zone is different" do
    params = %{expires_at: ~U[2000-01-02 00:15:00Z]}

    obj =
      Changeset.for_create(Emil.SimpleDomain.Token, :create, params)
      |> Ash.create!()
      |> Ash.load!([:is_utc_active, :is_seoul_active])

    assert obj.is_utc_active == obj.is_seoul_active
  end
end
