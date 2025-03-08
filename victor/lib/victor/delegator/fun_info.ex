defmodule Victor.Delegator.FunInfo do
  @enforce_keys [:mod, :name, :arity, :defaults, :args, :doc]
  defstruct @enforce_keys

  def list_infos(mod, name) do
    case Code.fetch_docs(mod) do
      {:docs_v1, _anot, _beam_language, _format, _module_doc, _meta, docs} ->
        for doc_element <- list_doc_elements(docs, name) do
          %__MODULE__{
            mod: mod,
            name: name,
            arity: get_arity(doc_element),
            defaults: get_defaults(doc_element),
            args: list_args(doc_element),
            doc: get_doc(doc_element)
          }
        end

      {:error, _reason} ->
        []
    end
  end

  defp list_doc_elements(docs, name) do
    for {{:function, ^name, _a}, _anot, _sigs, _doc_content, _meta} = element <- docs do
      element
    end
  end

  defp get_arity({{:function, _f, arity}, _anot, _sigs, _doc_content, _meta}) do
    arity
  end

  defp get_defaults({{:function, _f, _a}, _anot, _sigs, _doc_content, metadata}) do
    Map.get(metadata, :defaults, 0)
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
end
