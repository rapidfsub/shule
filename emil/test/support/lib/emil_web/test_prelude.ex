defmodule EmilWeb.TestPrelude do
  defmacro __using__(_opts) do
    quote do
      use Emil.TestPrelude
      use EmilWeb.Prelude
    end
  end
end
