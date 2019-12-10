defmodule NyannyanRaceBot.Command.RaceCommand do
  use Alchemy.Cogs

  alias NyannyanRaceBot.Task.RaceTask

  Cogs.def nyan do
    {:ok, guild} = Cogs.guild()
    spacer = guild.emojis |> Enum.find(&(&1.name == "space"))

    spacer =
      if spacer do
        "<:#{spacer.name}:#{spacer.id}>"
      else
        "　 "
      end

    {:ok, pid} = RaceTask.start_link(message.channel_id, spacer)
    RaceTask.run(pid)
  end
end
