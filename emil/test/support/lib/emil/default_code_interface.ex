defmodule Emil.DefaultCodeInterface do
  use Emil.TestPrelude

  defmodule Transformer do
    use Spark.Dsl.Transformer

    @impl Spark.Dsl.Transformer
    def after?(_module) do
      true
    end

    @impl Spark.Dsl.Transformer
    def transform(state) do
      for action <- SparkKit.get_entities(state, [:actions]),
          action.type in [:create, :update],
          reduce: state do
        state ->
          opts =
            case action.accept ++ Enum.map(action.arguments, & &1.name) do
              args when length(args) < 3 -> [args: args]
              _ -> []
            end

          SparkKit.add_new_interface(state, action.name, opts)
      end
    end
  end

  use Spark.Dsl.Extension, transformers: [Transformer]
end
