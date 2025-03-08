defmodule Victor.Mixin do
  alias Victor.Mixin.FunInfo

  defmacro delegate_to(mod, fname, opts \\ []) do
    {mod, _bindings} = Code.eval_quoted(mod)
    dname = Keyword.get(opts, :alias, fname)
    arity_or_nil = Keyword.get(opts, :arity)

    for info <- FunInfo.list_infos(mod, fname) do
      opts = [to: info.mod, as: info.name]

      for arity <- (info.arity - info.defaults)..info.arity//1, arity_or_nil in [nil, arity] do
        args = Enum.take(info.args, arity)

        quote do
          @doc unquote(info.doc)
          defdelegate unquote({dname, [], args}), unquote(opts)
        end
      end
    end
  end
end
