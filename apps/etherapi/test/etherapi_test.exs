defmodule EtherapiTest do
  use ExUnit.Case
  doctest Etherapi

  test "greets the world" do
    assert Etherapi.hello() == :world
  end
end
