defmodule Victor.Mixin do
  alias Victor.Mixin.FunInfo

  defmacro delegate_to(mod, fname, arity, opts \\ []) do
    {mod, _bindings} = Code.eval_quoted(mod)
    {:ok, info} = FunInfo.new(mod, fname, arity)
    dname = Keyword.get(opts, :alias, info.name)
    opts = [to: info.mod, as: info.name]

    for arity <- (info.arity - info.defaults)..info.arity//1 do
      args = Enum.take(info.args, arity)

      quote do
        @doc unquote(info.doc)
        defdelegate unquote({dname, [], args}), unquote(opts)
      end
    end
  end
end
