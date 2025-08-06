defmodule Vomitex.Example.Registry do
  use Vomitex.Registry,
    specs: [
      [
        guide: Vomitex.Example.Guide,
        path: "hello.ex",
        module: "Vomitex.Example.Hello",
        opts: [world: true]
      ],
      [
        guide: Vomitex.Example.Guide,
        path: "void.ex",
        module: "Vomitex.Example.Void",
        opts: []
      ]
    ]
end
