defmodule Mix.Tasks.Vomit.Gen do
  use Mix.Task

  def run([reg]) do
    registry = Module.concat([reg])
    Code.ensure_loaded!(registry)

    for spec <- registry.specs() do
      guide = Keyword.fetch!(spec, :guide)
      path = Keyword.fetch!(spec, :path)
      args = Keyword.fetch!(spec, :args)
      attrs = guide.__info__(:attributes)
      module = Keyword.fetch!(spec, :module) |> List.wrap() |> Module.concat()

      if !File.exists?(path) do
        code =
          quote do
            defmodule unquote(module) do
              use Vomit.Marker
              mark(:gen_begin)
              mark(:gen_end)
            end
          end
          |> Macro.to_string()
          |> Code.format_string!()

        File.write!(path, code)
        File.write!(path, "\n", [:append])
      end

      {:__block__, _meta, vomits} =
        for vomit <- Keyword.get_values(attrs, :vomit) |> List.flatten() do
          case apply(guide, vomit, args) do
            nil -> ""
            ast -> Macro.to_string(ast)
          end
        end
        |> Enum.join("\n\n")
        |> Code.string_to_quoted!()

      new_code =
        File.read!(path)
        |> Code.string_to_quoted!()
        |> Macro.prewalk(fn
          {:__block__, meta, children} = ast ->
            with {first, [start | rest]} <-
                   Enum.split_while(children, &(!match?({:mark, _meta, [:gen_begin]}, &1))),
                 {_gen, last} <-
                   Enum.split_while(rest, &(!match?({:mark, _meta, [:gen_end]}, &1))) do
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
