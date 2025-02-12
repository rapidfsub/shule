defmodule Victor.Delegator do
  defmodule Extension do
    defmodule Define do
      @args [:name]
      @enforce_keys @args ++ [:arity, :as]
      defstruct @enforce_keys

      def entity() do
        %Spark.Dsl.Entity{
          target: __MODULE__,
          name: :define,
          args: @args,
          schema: [
            name: [
              type: :atom,
              required: true
            ],
            arity: [
              type: :integer
            ],
            as: [
              type: :atom
            ]
          ]
        }
      end
    end

    defmodule DelegateTo do
      @args [:target]
      @enforce_keys @args ++ [:only, :except, :entities, :defs]
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
              type: {:list, @f_or_fa},
              default: []
            ]
          ],
          entities: [
            defs: [Define.entity()]
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

  use Spark.Dsl,
    default_extensions: [
      extensions: [Extension]
    ]
end
