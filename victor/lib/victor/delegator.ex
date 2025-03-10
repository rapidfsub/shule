defmodule Victor.Delegator do
  defmacro delegate_to(mod, fname \\ nil, opts \\ []) do
    {mod, _bindings} = Code.eval_quoted(mod)
    arity_or_nil = Keyword.get(opts, :arity)

    for info <- __MODULE__.FunInfo.list_infos(mod, fname) do
      dname = Keyword.get(opts, :alias, info.name)
      opts = [to: info.mod, as: info.name]

      for arity <- (info.arity - info.defaults)..info.arity//1, arity_or_nil in [nil, arity] do
        args = Enum.take(info.args, arity)

        [
          if info.doc do
            quote do
              @doc unquote(info.doc)
            end
          end,
          quote do
            defdelegate unquote({dname, [], args}), unquote(opts)
          end
        ]
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Victor.Delegator, only: [delegate_to: 1, delegate_to: 2, delegate_to: 3]
    end
  end
end
