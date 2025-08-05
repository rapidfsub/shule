defmodule Vomit.Marker do
  defmacro mark(_marker) do
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__), only: [mark: 1]
    end
  end
end
