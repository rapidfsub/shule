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

  def list_trading_days(year) do
    df =
      FileKit.get_kospi_candles_path(year)
      |> DataFrame.from_parquet!()

    df[:TRD_DD]
    |> Series.replace("/", "-")
    |> Series.cast(:date)
    |> Series.sort()
  end

  def list_candles_lte(isin, date, count) do
    df =
      Stream.unfold(date.year, fn
        year ->
          case FileKit.get_candles_path(isin, year) |> DataFrame.from_parquet() do
            {:ok, df} -> {df, year - 1}
            {:error, _reason} -> nil
          end
      end)
      |> Enum.reduce_while(nil, fn df, acc ->
        acc =
          if acc do
            DataFrame.concat_rows(df, acc)
          else
            df
          end
          |> DataFrame.filter(less_equal(date, ^date))
          |> DataFrame.sort_by(date)
          |> DataFrame.tail(count)

        if DataFrame.n_rows(acc) < count do
          {:cont, acc}
        else
          {:halt, acc}
        end
      end)

    if df && DataFrame.n_rows(df) == count do
      df
    end
  end
end
