defmodule Vomit.Guide do
  defmacro def(call, expr \\ nil) do
    fname = elem(call, 0)

    quote do
      @vomit unquote(fname)
      Kernel.def(unquote(call), unquote(expr))
    end
  end

  defmacro __using__(opts) do
    {args, _opts} = Keyword.pop(opts, :args, quote(do: []))

    quote do
      @args unquote(args)
      Module.register_attribute(__MODULE__, :vomit, persist: true, accumulate: true)
      import Kernel, except: [def: 2, defp: 2]
      import unquote(__MODULE__), only: [def: 2]
    end
  end
end
