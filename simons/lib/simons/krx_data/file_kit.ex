defmodule Simons.KrxData.FileKit do
  use Simons.KrxData.Prelude

  def get_krx_data_dir() do
    get_dir([:code.priv_dir(:simons), "krx_data"])
  end

  def get_summaries_dir() do
    get_dir([get_krx_data_dir(), "summaries"])
  end

  def get_summaries_path() do
    Path.join([get_summaries_dir(), get_filename(".csv")])
  end

  def get_profiles_dir() do
    get_dir([get_krx_data_dir(), "profiles"])
  end

  def get_profile_path(isin) do
    get_dir([get_profiles_dir(), isin]) |> Path.join(get_filename(".csv"))
  end

  def get_candles_dir() do
    get_dir([get_krx_data_dir(), "candles"])
  end

  def get_candles_path(isin, year) do
    get_dir([get_candles_dir(), isin]) |> Path.join("#{year}.csv")
  end

  @date ~D[2025-08-08]
  defp get_filename(ext) do
    Calendar.strftime(@date, "%Y%m%d") <> ext
  end

  defp get_dir(list) do
    result = Path.join(list)
    File.mkdir_p!(result)
    result
  end
end
