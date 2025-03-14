defmodule Emil.MarketCap.CandleTest do
  use Emil.TestDataCase, async?: true

  test "create" do
    params = %{name: "admin"}
    assert bot = Changeset.for_create(Emil.MarketCap.Bot, :create, params) |> Ash.create!()

    params = %{
      open: Faker.Commerce.price(),
      high: Faker.Commerce.price(),
      low: Faker.Commerce.price(),
      close: Faker.Commerce.price()
    }

    assert Changeset.for_create(Emil.MarketCap.Candle, :create, params, actor: bot)
           |> Ash.create!()
  end
end
