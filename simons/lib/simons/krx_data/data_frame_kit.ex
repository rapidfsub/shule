defmodule Simons.KrxData.DataFrameKit do
  use Simons.KrxData.Prelude

  @mappings [
    표준코드: :isin,
    "한글 종목명": :name,
    시장구분: :market,
    주식종류: :type
  ]
  def get_summaries() do
    Simons.KrxData.FileKit.get_summaries_path()
    |> DataFrame.from_csv!()
    |> DataFrame.select(Keyword.keys(@mappings))
    |> DataFrame.rename(@mappings)
  end

  def get_isins() do
    Series.to_enum(get_summaries()[:isin])
  end
end
