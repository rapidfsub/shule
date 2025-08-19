defmodule Simons.KrxData do
  use Simons.KrxData.Prelude

  def run() do
    Crawler.fetch_kospi_candles()
  end
end
