defmodule NyannyanRaceBotTest do
  use ExUnit.Case
  doctest NyannyanRaceBot

  test "greets the world" do
    assert NyannyanRaceBot.hello() == :world
  end
end
