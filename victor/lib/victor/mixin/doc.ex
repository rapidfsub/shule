defmodule Victor.Mixin.FunInfo do
  @enforce_keys [:mod, :name, :arity, :defaults, :args, :doc]
  defstruct @enforce_keys

  def new(mod, name, arity) do
    with {:ok, docs} <- fetch_docs(mod),
         {:ok, doc_element} <- fetch_doc_element(docs, name, arity) do
      defaults = get_defaults(doc_element)
      args = list_args(doc_element)
      doc = get_doc(doc_element)

      info = %__MODULE__{
        mod: mod,
        name: name,
        arity: arity,
        defaults: defaults,
        args: args,
        doc: doc
      }

      {:ok, info}
    end
  end

  defp fetch_docs(mod) do
    case Code.fetch_docs(mod) do
      {:docs_v1, _anot, _beam_language, _format, _module_doc, _meta, docs} -> {:ok, docs}
      {:error, _reason} -> {:error, :invalid}
    end
  end

  defp fetch_doc_element(docs, name, arity) do
    Enum.find_value(docs, {:error, :not_found}, fn
      {{:function, ^name, ^arity}, _anot, _sigs, _doc_content, _meta} = element -> {:ok, element}
      _ -> nil
    end)
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
