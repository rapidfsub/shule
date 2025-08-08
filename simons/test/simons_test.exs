defmodule SimonsTest do
  use ExUnit.Case
  doctest Simons

  test "greets the world" do
    assert Simons.hello() == :world
  end
end
