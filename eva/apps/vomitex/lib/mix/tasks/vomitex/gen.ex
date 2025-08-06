defmodule Mix.Tasks.Vomitex.Gen do
  use Mix.Task

  @requirements ["loadpaths", "app.start"]
  def run(argv) do
    registry = Module.concat(argv)

    for raw_spec <- registry.specs() do
      guide = Keyword.fetch!(raw_spec, :guide)

      vomit_names =
        guide.__info__(:attributes)
        |> Keyword.get_values(:vomit)
        |> List.flatten()

      spec = %{
        path: Keyword.fetch!(raw_spec, :path),
        module: [Keyword.fetch!(raw_spec, :module)] |> Module.concat(),
        guide: guide,
        vomit_names: vomit_names,
        opts: Keyword.fetch!(raw_spec, :opts),
        hash: :erlang.phash2(raw_spec)
      }

      if File.exists?(spec.path) do
        spec.path
        |> File.read!()
        |> Code.string_to_quoted!()
        |> Macro.prewalk(%{marker_count: 0, matching_hash_count: 0}, fn
          {:mark_vomitted, _meta, [vomit_meta, _block]} = ast, acc ->
            acc =
              acc
              |> Map.update!(:marker_count, &(&1 + 1))
              |> Map.update!(:matching_hash_count, fn count ->
                if Keyword.fetch!(vomit_meta, :hash) == spec.hash do
                  count + 1
                else
                  count
                end
              end)

            {ast, acc}

          ast, acc ->
            {ast, acc}
        end)
      end
      |> case do
        {_ast, %{marker_count: 1, matching_hash_count: 1}} ->
          :ok

        _ ->
          quote do
            defmodule unquote(spec.module) do
              use Vomitex.Marker

              mark_vomitted(hash: unquote(spec.hash)) do
              end
            end
          end
          |> Macro.to_string()
          |> Code.format_string!()
          |> write_file(spec.path)

          vomits =
            for vomit_name <- spec.vomit_names,
                vomit = apply(spec.guide, vomit_name, [spec.opts]) do
              vomit
            end
            |> Macro.to_string()
            |> Code.string_to_quoted!()

          File.read!(spec.path)
          |> Code.string_to_quoted!()
          |> Macro.prewalk(fn
            {:mark_vomitted, meta, [vomit_meta, _block]} ->
              {:mark_vomitted, meta, [vomit_meta, [do: {:__block__, [], vomits}]]}

            ast ->
              ast
          end)
          |> Macro.to_string()
          |> Code.format_string!()
          |> write_file(spec.path)
      end
    end

    :ok
  end

  defp write_file(content, path) do
    File.write!(path, content)
    File.write!(path, "\n", [:append])
  end
end
