defmodule Emil.Prelude do
  defmacro __using__(_opts) do
    quote do
      alias Emil.Changeset
    end
  end
end
