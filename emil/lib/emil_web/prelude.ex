defmodule EmilWeb.Prelude do
  defmacro __using__(_opts) do
    quote do
      use Emil.Prelude

      alias EmilWeb.Form
    end
  end
end
