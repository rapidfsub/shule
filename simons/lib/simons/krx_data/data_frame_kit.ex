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

  def merge_profiles() do
    path = FileKit.get_profiles_path()

    if not File.exists?(path) do
      for dir <- FileKit.get_profiles_dir() |> File.ls!(),
          path = FileKit.get_profiles_dir() |> Path.join(dir),
          File.dir?(path),
          filename <- File.ls!(path) do
        df = Path.join(path, filename) |> DataFrame.from_csv!()

        df
        |> DataFrame.mutate(
          PARVAL: cast(^df[:PARVAL], :string) |> cast(:u64),
          CORP_TEL_NO: cast(^df[:CORP_TEL_NO], :string),
          ISU_SRT_CD: cast(^df[:ISU_SRT_CD], :string)
        )
      end
      |> DataFrame.concat_rows()
      |> DataFrame.to_parquet!(path)
    end

    DataFrame.from_parquet!(path)
  end
end
