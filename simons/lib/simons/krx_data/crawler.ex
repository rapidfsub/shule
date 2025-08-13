defmodule Simons.KrxData.Crawler do
  use Simons.KrxData.Prelude

  def fetch_profiles() do
    crawl(fn isin ->
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

  def fetch_candles(s_date, e_date) do
    crawl(fn isin ->
      path = FileKit.get_candles_path(isin, s_date.year)

      if File.exists?(path) do
        {:error, :already_exists}
      else
        resp = ApiClient.get_candles(isin, s_date, e_date)

        resp.body
        |> Map.fetch!("output")
        |> DataFrame.new()
        |> DataFrame.to_csv!(path)
      end
    end)
  end

  defp crawl(fun) do
    for isins <- DataFrameKit.get_isins() |> Enum.chunk_every(500) do
      if :ok in do_crawl(isins, fun) do
        for _ <- 1..6 do
          sleep(10)
        end
      else
        {:error, :no_sleep}
      end
    end
  end

  defp do_crawl(isins, fun) do
    for isins <- Enum.chunk_every(isins, 5) do
      results =
        for isin <- isins do
          Task.async(fn ->
            fun.(isin)
          end)
        end
        |> Task.await_many(:timer.minutes(1))

      inspect(event_name: :crawl, attributes: [isins: isins, results: results]) |> Logger.info()

      if :ok in results do
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
