alias Emil.AshPostgres.ExpressionTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest do
  use Emil.TestDataCase, async?: true

  # lazy를 이용해 DateTime 값을 사용할 때 time zone이 사라지는 ash_sql의 버그에 대한 재현 테스트
  # https://github.com/ash-project/ash_sql/issues/140
  test "should be equal even if the time zone is different" do
    params = %{expires_at: FakeDateTime.utc_now() |> DateTime.shift(minute: 15)}

    obj =
      Changeset.for_create(ThisTest.Token, :create, params)
      |> Ash.create!()
      |> Ash.load!([:is_utc_active, :is_seoul_active])

    assert true = obj.is_utc_active
    assert true = obj.is_seoul_active
  end
end
