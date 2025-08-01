defmodule Emil.Prelude do
  defmacro __using__(_opts) do
    quote do
      alias Emil.Changeset
      alias Emil.SparkKit
    end
  end
end
