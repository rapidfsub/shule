defmodule Mixin do
  defp list_delegates(mod, fname, opts, pred) do
    {mod, _bindings} = Code.eval_quoted(mod)
    arity_or_nil = Keyword.get(opts, :arity)

    for info <- __MODULE__.FunInfo.list_infos(mod, fname), pred.(info) do
      dname = Keyword.get(opts, :alias, info.name)
      opts = [to: info.mod, as: info.name]

      for arity <- (info.arity - info.defaults)..info.arity//1, arity_or_nil in [nil, arity] do
        args = Enum.take(info.args, arity)

        [
          quote do
            if Module.defines?(__MODULE__, unquote({dname, arity})) do
              raise "#{unquote(inspect({dname, arity}))} already defined"
            end
          end,
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

  defmacro mixin(mod, opts \\ []) do
    only = Keyword.get(opts, :only, nil)
    except = Keyword.get(opts, :except, [])

    list_delegates(mod, nil, opts, fn info ->
      (!only || info.name in only) && info.name not in except
    end)
  end

  defmacro delegate_to(mod, fname, opts \\ []) do
    list_delegates(mod, fname, opts, &Function.identity/1)
  end

  defmacro __using__(_opts) do
    quote do
      import Mixin, only: [mixin: 1, mixin: 2, delegate_to: 2, delegate_to: 3]
    end
  end
end
