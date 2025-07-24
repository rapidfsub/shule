defmodule Emil.AshPostgresHelper do
  defmacro __using__(_opts) do
    schema = Path.basename(__CALLER__.file, ".ex")

    table =
      __CALLER__.module
      |> Module.split()
      |> Enum.fetch!(-1)
      |> Macro.underscore()

    quote do
      postgres do
        schema unquote(schema)
        table unquote(table)
        repo Emil.TestRepo
      end
    end
  end
end
