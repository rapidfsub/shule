defmodule VoidTest do
  use ExUnit.Case
  doctest Void

  test "greets the world" do
    assert Void.hello() == :world
  end
end
