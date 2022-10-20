defmodule DemosTest do
  use ExUnit.Case
  doctest Demos

  test "greets the world" do
    assert Demos.hello() == :world
  end
end
