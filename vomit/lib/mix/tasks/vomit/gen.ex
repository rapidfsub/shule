defmodule Mix.Tasks.Vomit.Gen do
  use Mix.Task

  def run([reg]) do
    registry = Module.concat([reg])
    Code.ensure_loaded!(registry)

    for raw_spec <- registry.specs() do
      spec = get_spec(raw_spec)
      old_code_info = get_old_code_info(spec)

      if old_code_info.hash != spec.hash do
        get_new_code_str(spec, old_code_info) |> write_file(spec.path)
      end
    end
  end

  defp get_spec(raw_spec) do
    guide = Keyword.fetch!(raw_spec, :guide)
    Code.ensure_loaded!(guide)

    vomit =
      guide.__info__(:attributes)
      |> Keyword.get_values(:vomit)
      |> List.flatten()

    %{
      path: Keyword.fetch!(raw_spec, :path),
      module: Keyword.fetch!(raw_spec, :module) |> List.wrap() |> Module.concat(),
      guide: guide,
      vomit: vomit,
      opts: Keyword.fetch!(raw_spec, :opts),
      hash: :erlang.phash2(raw_spec)
    }
  end

  defp get_old_code_info(spec) do
    result = do_get_old_code_info(spec.path)

    if result do
      result
    else
      generate_base_code_str(spec.module) |> write_file(spec.path)
      do_get_old_code_info(spec.path)
    end
  end

  defp do_get_old_code_info(path) do
    with {:ok, file} <- File.read(path),
         {:ok, quoted} <- Code.string_to_quoted(file) do
      quoted
      |> Macro.prewalk(nil, fn
        {:__block__, meta, children} = ast, nil ->
          start_index = find_marker_index(children, &(&1 == :gen_begin))
          end_index = find_marker_index(children, &(&1 == :gen_end))

          if start_index && end_index do
            hash =
              find_marker_value(children, fn
                {:hash, hash} -> hash
                _ -> nil
              end)

            meta = Keyword.put(meta, :vomit_target, true)

            {{:__block__, meta, children},
             %{start_index: start_index, end_index: end_index, hash: hash}}
          else
            {ast, nil}
          end

        ast, acc ->
          {ast, acc}
      end)
      |> case do
        {_ast, nil} -> nil
        {ast, acc} -> Map.merge(acc, %{quoted: ast})
      end
    else
      _ -> nil
    end
  end

  defp find_marker_index(nodes, pred) do
    Enum.find_index(nodes, fn
      {:mark, _meta, [[do: marker]]} -> pred.(marker)
      _ -> false
    end)
  end

  defp find_marker_value(nodes, fun) do
    Enum.find_value(nodes, fn
      {:mark, _meta, [[do: marker]]} -> fun.(marker)
      _ -> nil
    end)
  end

  defp generate_base_code_str(module) do
    quote do
      defmodule unquote(module) do
        use Vomit.Marker

        mark do
          :gen_begin
        end

        mark do
          :gen_end
        end
      end
    end
    |> Macro.to_string()
    |> Code.format_string!()
  end

  defp get_new_code_str(spec, code_info) do
    code_info.quoted
    |> Macro.prewalk(fn
      {:__block__, meta, children} = ast ->
        if meta[:vomit_target] do
          {front, _gen} = Enum.split(children, code_info.start_index + 1)
          {_gen, back} = Enum.split(children, code_info.end_index)

          quoted_hash =
            quote do
              mark do
                {:hash, unquote(spec.hash)}
              end
            end

          {:__block__, meta, front ++ [quoted_hash] ++ get_vomit(spec) ++ back}
        else
          ast
        end

      ast ->
        ast
    end)
    |> Macro.to_string()
    |> Code.format_string!()
  end

  defp get_vomit(spec) do
    for vomit <- spec.vomit, ast = apply(spec.guide, vomit, [spec.opts]) do
      Macro.to_string(ast)
    end
    |> Enum.join("\n\n")
    |> Code.string_to_quoted!()
    |> case do
      {:__block__, _meta, vomits} -> vomits
      vomit -> [vomit]
    end
  end

  defp write_file(content, path) do
    File.write!(path, content)
    File.write!(path, "\n", [:append])
  end
end
