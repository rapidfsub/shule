defmodule VomitTest do
  use ExUnit.Case
  doctest Vomit

  test "greets the world" do
    assert Vomit.hello() == :world
  end
end
