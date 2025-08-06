defmodule Vomitex.Example.Guide do
  use Vomitex.Guide

  def optionally_define_world(opts) do
    if opts[:world] do
      quote do
        def world() do
          IO.puts("Hello, world!")
        end
      end
    end
  end
end
