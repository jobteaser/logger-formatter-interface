defmodule Logger.Formatter.JSONTest do
  use ExUnit.Case
  doctest Logger.Formatter.JSON

  test "greets the world" do
    assert Logger.Formatter.JSON.hello() == :world
  end
end
