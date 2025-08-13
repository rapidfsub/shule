defmodule Simons.KrxData.Crawler do
  use Simons.KrxData.Prelude

  def fetch_profiles() do
    for isins <- Simons.KrxData.DataFrameKit.get_isins() |> Enum.chunk_every(500) do
      results = do_fetch_profiles(isins)

      if Enum.any?(results, &(&1 == :ok)) do
        for _ <- 1..6 do
          sleep(10)
        end
      else
        {:error, :no_sleep}
      end
    end
  end

  defp do_fetch_profiles(isins) do
    for isins <- Enum.chunk_every(isins, 5) do
      results =
        for isin <- isins do
          Task.async(fn ->
            path = FileKit.get_profile_path(isin)

            if File.exists?(path) do
              {:error, :already_exists}
            else
              resp = ApiClient.get_profile(isin)

              resp.body
              |> List.wrap()
              |> DataFrame.new()
              |> DataFrame.to_csv!(path)
            end
          end)
        end
        |> Task.await_many()

      inspect(event_name: :fetch, attributes: [isins: isins, results: results]) |> Logger.info()

      if Enum.any?(results, &(&1 == :ok)) do
        sleep(1)
      else
        {:error, :no_sleep}
      end
    end
  end

  def fetch_candles(s_date, e_date) do
    for isins <- Simons.KrxData.DataFrameKit.get_isins() |> Enum.chunk_every(500) do
      results = do_fetch_candles(isins, s_date, e_date)

      if Enum.any?(results, &(&1 == :ok)) do
        for _ <- 1..6 do
          sleep(10)
        end
      else
        {:error, :no_sleep}
      end
    end
  end

  defp do_fetch_candles(isins, s_date, e_date) do
    for isins <- Enum.chunk_every(isins, 5) do
      results =
        for isin <- isins do
          Task.async(fn ->
            filename = FileKit.get_candles_path(isin, s_date.year)

            if File.exists?(filename) do
              {:error, :already_exists}
            else
              resp = ApiClient.get_candles(isin, s_date, e_date)

              resp.body
              |> Map.fetch!("output")
              |> DataFrame.new()
              |> DataFrame.to_csv!(filename)
            end
          end)
        end
        |> Task.await_many()

      inspect(event_name: :fetch, attributes: [isins: isins, results: results]) |> Logger.info()

      if Enum.any?(results, &(&1 == :ok)) do
        sleep(1)
      else
        {:error, :no_sleep}
      end
    end
  end

  defp sleep(seconds) do
    :timer.seconds(seconds) |> Process.sleep()
    inspect(event_name: :sleep, attributes: [seconds: seconds]) |> Logger.info()
    :ok
  end
end
