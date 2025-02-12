defmodule Victor.Delegator.Transformer do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  @impl Transformer
  def transform(state) do
    delegates =
      for delegate_to <- Transformer.get_entities(state, [:delegates]), into: %{} do
        {delegate_to.target, delegate_to}
      end

    for {target, delegate_to} <- delegates, reduce: {:ok, state} do
      {:ok, state} ->
        only = delegate_to.only && MapSet.new(delegate_to.only)
        except = MapSet.new(delegate_to.except)

        defs =
          for define <- delegate_to.defs, into: %{} do
            as_or_name = define.as || define.name

            key =
              if define.arity do
                {as_or_name, define.arity}
              else
                as_or_name
              end

            {key, define}
          end

        for faad <- list_faads(target),
            {fname, args, doc, opts} <- list_fados(faad, only, except, defs, to: target),
            reduce: {:ok, state} do
          {:ok, state} ->
            delegate = get_delegate(fname, args, doc, opts)
            {:ok, Transformer.eval(state, [], delegate)}
        end
    end
  end

  defp list_faads(target) do
    case Code.fetch_docs(target) do
      {:docs_v1, _annotation, _beam_language, _format, _module_doc, _metadata, docs} ->
        for doc <- docs, faad <- list_doc_faads(doc) do
          faad
        end

      {:error, _reason} ->
        for {fname, aty} <- target.__info__(:functions) do
          # faad
          {fname, aty, get_dummy_args(aty), nil}
        end
    end
  end

  defp list_doc_faads({{:function, _fname, _aty}, _annotation, _signature, :hidden, _metadata}) do
    []
  end

  defp list_doc_faads({{:function, fname, _aty}, _annotation, [sig], doc_content, metadata}) do
    {^fname, _meta, args_with_defaults} = Code.string_to_quoted!(sig)
    arity = length(args_with_defaults)
    defaults = Map.get(metadata, :defaults, 0)

    args =
      Enum.map(args_with_defaults, fn
        {:\\, _meta, [arg, _default]} -> arg
        arg -> arg
      end)

    doc =
      case doc_content do
        :none -> nil
        %{} -> Enum.fetch!(doc_content, 0) |> elem(1)
      end

    for aty <- (arity - defaults)..arity//1 do
      # faad
      {fname, aty, Enum.take(args, aty), doc}
    end
  end

  defp list_doc_faads(_doc) do
    []
  end

  defp get_dummy_args(arity) do
    for aty <- 1..arity//1 do
      Macro.var(:"x#{aty}", nil)
    end
  end

  defp list_fados({fname, arity, args, doc}, only, except, defs, opts) do
    keys = MapSet.new([fname, {fname, arity}])
    define = Map.get(defs, fname) || Map.get(defs, {fname, arity})

    [
      if !(only && MapSet.disjoint?(only, keys)) && MapSet.disjoint?(except, keys) do
        # fado
        {fname, args, doc, opts}
      end,
      if define do
        as_or_name = define.as || define.name
        # fado
        {define.name, args, doc, Keyword.put(opts, :as, as_or_name)}
      end
    ]
    |> Enum.filter(&Function.identity/1)
  end

  defp get_delegate(fname, args, doc, opts) do
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
