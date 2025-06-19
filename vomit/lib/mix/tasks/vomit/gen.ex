defmodule Mix.Tasks.Vomit.Gen do
  use Mix.Task

  def run([reg]) do
    registry = Module.concat([reg])
    Code.ensure_loaded!(registry)

    for spec <- registry.specs() do
      guide = Keyword.fetch!(spec, :guide)
      Code.ensure_loaded!(guide)

      path = Keyword.fetch!(spec, :path)
      opts = Keyword.fetch!(spec, :opts)
      attrs = guide.__info__(:attributes)
      module = Keyword.fetch!(spec, :module) |> List.wrap() |> Module.concat()

      if !File.exists?(path) do
        code =
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

        File.write!(path, code)
        File.write!(path, "\n", [:append])
      end

      vomits =
        for vomit <- Keyword.get_values(attrs, :vomit) |> List.flatten() do
          case apply(guide, vomit, [opts]) do
            nil -> ""
            ast -> Macro.to_string(ast)
          end
        end
        |> Enum.join("\n\n")
        |> Code.string_to_quoted!()
        |> case do
          {:__block__, _meta, vomits} -> vomits
          vomit -> [vomit]
        end

      new_code =
        File.read!(path)
        |> Code.string_to_quoted!()
        |> Macro.prewalk(fn
          {:__block__, meta, children} = ast ->
            with {first, [start | rest]} <-
                   Enum.split_while(children, &(!match?({:mark, _meta, [[do: :gen_begin]]}, &1))),
                 {_gen, last} <-
                   Enum.split_while(rest, &(!match?({:mark, _meta, [[do: :gen_end]]}, &1))) do
              {:__block__, meta, first ++ [start] ++ vomits ++ last}
            else
              _ -> ast
            end

          ast ->
            ast
        end)
        |> Macro.to_string()
        |> Code.format_string!()

      File.write!(path, new_code)
      File.write!(path, "\n", [:append])
    end
  end
end
