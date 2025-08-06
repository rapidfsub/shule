defmodule Vomitex.Marker do
  defmacro mark_vomitted(_metadata, do: block) do
    block
  end

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__), only: [mark_vomitted: 2]
    end
  end
end
