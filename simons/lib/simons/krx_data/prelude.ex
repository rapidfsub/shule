defmodule Simons.KrxData.Prelude do
  defmacro __using__(_opts) do
    quote do
      alias Explorer.DataFrame
      alias Explorer.Series

      require Explorer.DataFrame
      require Logger

      alias Simons.KrxData.ApiClient
      alias Simons.KrxData.Crawler
      alias Simons.KrxData.DataFrameKit
      alias Simons.KrxData.FileKit
    end
  end
end
