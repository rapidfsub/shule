defmodule Emil.MarketCap do
  use Ash.Domain

  resources do
    resource Emil.MarketCap.Candle
  end
end
