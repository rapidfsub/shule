defmodule Victor.Defrelay.DefaultDsl do
  defmodule Relay do
    @args [:fun]
    @enforce_keys @args ++ []
    defstruct @enforce_keys

    def entity() do
      %Spark.Dsl.Entity{
        target: __MODULE__,
        name: :relay,
        args: @args,
        schema: [
          fun: [
            type: :atom,
            required: true
          ]
        ]
      }
    end
  end

  defmodule Target do
    @args [:mod]
    @enforce_keys @args ++ [:relays]
    defstruct @enforce_keys

    def entity() do
      %Spark.Dsl.Entity{
        target: __MODULE__,
        name: :target,
        args: @args,
        schema: [
          mod: [
            type: :atom,
            required: true
          ]
        ],
        entities: [
          relays: [Relay.entity()]
        ]
      }
    end
  end

  @defrelay %Spark.Dsl.Section{
    name: :defrelay,
    entities: [
      Target.entity()
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@defrelay],
    transformers: [Victor.Defrelay.Transformer]
end
