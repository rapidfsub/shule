defmodule Victor.Defrelay.Transformer do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  @impl true
  def transform(state) do
    for target <- Transformer.get_entities(state, [:defrelay]),
        relay <- target.relays,
        reduce: {:ok, state} do
      {:ok, state} ->
        blocks =
          for info <- list_info(target.mod, relay.fun) do
            get_block(target.mod, info)
          end

        {:ok, Transformer.eval(state, [], blocks)}
    end
  end

  def list_info(mod, fun) do
    case list_info_from_docs(mod, fun) do
      [] -> list_info_from_module(mod, fun)
      result -> result
    end
    |> case do
      [] -> raise "#{inspect({mod, fun})} not found"
      result -> result
    end
  end

  def list_info_from_docs(mod, fun) do
    case Code.fetch_docs(mod) do
      {:docs_v1, _annotation, _beam_language, _format, _module_doc, _metadata, docs} ->
        for doc =
              {{:function, ^fun, _arity}, _annotation, _signature, %{} = _doc_content, _metadata} <-
              docs,
            info <- list_info_from_doc(doc) do
          info
        end

      {:error, _reason} ->
        []
    end
  end

  def list_info_from_doc({{:function, fun, arity}, _annotation, [sig], doc_content, metadata}) do
    {^fun, _fun_meta, fun_args} = Code.string_to_quoted!(sig)

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

    for a <- (arity - defaults)..arity//1 do
      {fun, Enum.take(args, a), doc}
    end
  end

  def get_block(mod, {fun, args, doc}) do
    quote do
      if unquote(doc) do
        @doc unquote(doc)
      end

      defdelegate unquote({fun, [], args}), to: unquote(mod)
    end
  end

  def list_info_from_module(mod, fun) do
    for {^fun, arity} <- mod.__info__(:functions) do
      args = get_dummy_args(arity)
      {fun, args, nil}
    end
  end

  def get_dummy_args(arity) do
    for _a <- 1..arity//1 do
      Macro.var(:"x#{arity}", nil)
    end
  end
end
