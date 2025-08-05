defmodule MixinTest do
  use ExUnit.Case
  doctest Mixin

  test "greets the world" do
    assert Mixin.hello() == :world
  end
end
