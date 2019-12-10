defmodule NyannyanRaceBot.Application do
  use Application

  alias Alchemy.Client
  alias NyannyanRaceBot.Commands

  @token Application.get_env(:nyannyan_race_bot, :token)

  def start(_type, _args) do
    run = Client.start(@token)
    use Commands
    run
  end
end
