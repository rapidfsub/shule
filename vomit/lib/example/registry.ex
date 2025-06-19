defmodule Example.Registry do
  use Vomit.Registry,
    specs: [
      [
        guide: Example.Guide,
        path: "hello.ex",
        module: "Example.Hello",
        opts: []
      ],
      [
        guide: Example.Guide,
        path: "hello_world.ex",
        module: "Example.HelloWorld",
        opts: [world: true]
      ]
    ]
end
