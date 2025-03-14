defmodule Emil.TestPrelude do
  defmacro __using__(_opts) do
    quote do
      use Emil.Prelude
    end
  end
end
