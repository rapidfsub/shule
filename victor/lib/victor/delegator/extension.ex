defmodule Victor.Delegator.Extension do
  defmodule DelegateTo do
    @args [:target]
    @enforce_keys @args ++ [:only, :except]
    defstruct @enforce_keys

    @f_or_fa {:or, [:atom, {:tuple, [:atom, :non_neg_integer]}]}

    def entity() do
      %Spark.Dsl.Entity{
        target: __MODULE__,
        name: :delegate_to,
        args: @args,
        schema: [
          target: [
            type: :atom,
            required: true
          ],
          only: [
            type: {:list, @f_or_fa}
          ],
          except: [
            type: {:list, @f_or_fa}
          ]
        ]
      }
    end
  end

  @delegates %Spark.Dsl.Section{
    name: :delegates,
    entities: [DelegateTo.entity()],
    top_level?: true
  }

  use Spark.Dsl.Extension,
    sections: [@delegates],
    transformers: [Victor.Delegator.Transformer]
end
