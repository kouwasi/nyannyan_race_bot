defmodule NyannyanRaceBot.Commands do
  @moduledoc """
  コマンドのエントリポイント
  """
  alias NyannyanRaceBot.Command

  defmacro __using__(_opts) do
    quote do
      use Command.RaceCommand
    end
  end
end
