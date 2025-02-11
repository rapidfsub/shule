defmodule Victor.Delegator.DefaultDsl do
  defmodule Delegate do
    @args [:fname]
    @enforce_keys @args ++ [:as]
    defstruct @enforce_keys

    def entity() do
      %Spark.Dsl.Entity{
        target: __MODULE__,
        name: :delegate,
        args: @args,
        schema: [
          fname: [
            type: :atom,
            required: true
          ],
          as: [
            type: :atom
          ]
        ]
      }
    end
  end

  defmodule To do
    @args [:mod]
    @enforce_keys @args ++ [:delegates]
    defstruct @enforce_keys

    def entity() do
      %Spark.Dsl.Entity{
        target: __MODULE__,
        name: :to,
        args: @args,
        schema: [
          mod: [
            type: :atom,
            required: true
          ]
        ],
        entities: [
          delegates: [Delegate.entity()]
        ]
      }
    end
  end

  @delegates %Spark.Dsl.Section{
    name: :delegates,
    entities: [To.entity()]
  }

  use Spark.Dsl.Extension,
    sections: [@delegates],
    transformers: [Victor.Delegator.Transformer]
end
