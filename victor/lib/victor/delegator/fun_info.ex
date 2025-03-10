defmodule Victor.Delegator.FunInfo do
  @enforce_keys [:mod, :name, :arity, :defaults, :args, :doc]
  defstruct @enforce_keys

  def list_infos(mod, name) do
    case Code.fetch_docs(mod) do
      {:docs_v1, _anot, _beam_language, _format, _module_doc, _meta, docs} ->
        for doc_element <- list_doc_elements(docs, name) do
          %__MODULE__{
            mod: mod,
            name: get_name(doc_element),
            arity: get_arity(doc_element),
            defaults: get_defaults(doc_element),
            args: list_args(doc_element),
            doc: get_doc(doc_element)
          }
        end

      {:error, _reason} ->
        for {mod, name, arity} <- list_mfas(mod, name) do
          %__MODULE__{
            mod: mod,
            name: name,
            arity: arity,
            defaults: 0,
            args: list_dummy_args(arity),
            doc: nil
          }
        end
    end
  end

  defp list_doc_elements(docs, name) do
    for {{:function, f, _a}, _anot, _sigs, _doc_content, _meta} = element <- docs,
        name in [nil, f] do
      element
    end
  end

  defp get_name({{:function, f, _a}, _anot, _sigs, _doc_content, _meta}) do
    f
  end

  defp get_arity({{:function, _f, a}, _anot, _sigs, _doc_content, _meta}) do
    a
  end

  defp get_defaults({{:function, _f, _a}, _anot, _sigs, _doc_content, meta}) do
    Map.get(meta, :defaults, 0)
  end

  defp list_args({{:function, _f, _a}, _anot, [sig], _doc_content, _meta}) do
    {_f, _meta, args} = Code.string_to_quoted!(sig)

    Enum.map(args, fn
      {:\\, _meta, [arg, _default]} -> arg
      arg -> arg
    end)
  end

  defp get_doc({{:function, _f, _a}, _anot, _sigs, doc_content, _meta}) do
    case doc_content do
      %{"en" => doc} -> doc
      :none -> nil
      :hidden -> nil
    end
  end

  defp list_mfas(mod, name) do
    for {f, a} <- mod.__info__(:functions), name in [nil, f] do
      {mod, f, a}
    end
  end

  defp list_dummy_args(arity) do
    for arity <- 1..arity//1 do
      Macro.var(:"x#{arity}", nil)
    end
  end
end
