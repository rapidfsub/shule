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
end
