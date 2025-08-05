defmodule Example.Guide do
  use Vomit.Guide

  def define_hello(_opts) do
    quote do
      def hello() do
        :hello
      end
    end
  end

  def optionally_define_world(opts) do
    if opts[:world] do
      quote do
        def world() do
          :world
        end
      end
    end
  end

  def define_add(opts) do
    offset = Keyword.get(opts, :offset, 1)

    quote do
      def add(x) do
        x + unquote(offset)
      end
    end
  end
end
