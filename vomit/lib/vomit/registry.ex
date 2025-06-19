defmodule Vomit.Registry do
  @type spec() :: [guide: module(), path: binary(), module: binary(), opts: keyword()]
  @callback specs() :: [spec()]

  defmacro __using__(opts) do
    dirname = __CALLER__.file |> Path.dirname()

    specs =
      for spec <- Keyword.fetch!(opts, :specs) do
        Keyword.update!(spec, :path, fn path ->
          Path.join(dirname, path) |> Path.expand()
        end)
      end

    quote do
      @behaviour Vomit.Registry

      @impl Vomit.Registry
      def specs() do
        unquote(specs)
      end
    end
  end
end
