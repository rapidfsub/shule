defmodule Victor.Delegator.Transformer do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  @impl true
  def transform(state) do
    for to <- Transformer.get_entities(state, [:delegates]),
        delegate <- to.delegates,
        reduce: {:ok, state} do
      {:ok, state} ->
        orig_fname = delegate.as || delegate.fname

        blocks =
          for {args, doc} <- list_info(to.mod, orig_fname) do
            get_block(delegate.fname, args, doc, to: to.mod, as: orig_fname)
          end

        {:ok, Transformer.eval(state, [], blocks)}
    end
  end

  defp list_info(mod, fname) do
    case list_info_from_docs(mod, fname) do
      [] -> list_info_from_module(mod, fname)
      result -> result
    end
    |> case do
      [] -> raise "#{inspect({mod, fname})} not found"
      result -> result
    end
  end

  defp list_info_from_docs(mod, fname) do
    case Code.fetch_docs(mod) do
      {:docs_v1, _annotation, _beam_language, _format, _module_doc, _metadata, docs} ->
        for doc = {{:function, ^fname, _arity}, _annotation, _signature, _doc_content, _metadata} <-
              docs,
            info <- list_info_from_doc(doc) do
          info
        end

      {:error, _reason} ->
        []
    end
  end

  defp list_info_from_doc({{:function, fname, arity}, _annotation, [sig], doc_content, metadata}) do
    {^fname, _fun_meta, fun_args} = Code.string_to_quoted!(sig)

    args =
      Enum.map(fun_args, fn
        {:\\, _meta, [arg, _default]} -> arg
        arg -> arg
      end)

    defaults = Map.get(metadata, :defaults, 0)

    doc =
      case doc_content do
        :none -> nil
        %{} -> Enum.fetch!(doc_content, 0) |> elem(1)
      end

    for aty <- (arity - defaults)..arity//1 do
      {Enum.take(args, aty), doc}
    end
  end

  defp list_info_from_module(mod, fname) do
    for {^fname, arity} <- mod.__info__(:functions) do
      args =
        for aty <- 1..arity//1 do
          Macro.var(:"x#{aty}", nil)
        end

      {args, nil}
    end
  end

  defp get_block(fname, args, doc, opts) do
    [
      if doc do
        quote do
          @doc unquote(doc)
        end
      end,
      quote do
        defdelegate unquote({fname, [], args}), unquote(opts)
      end
    ]
  end
end
