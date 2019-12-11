defmodule NyannyanRaceBot.Task.RaceTask do
  use GenServer

  alias Alchemy.Client

  @cat ":cat2:"
  @header "―――――――――――――――――――――――――――"

  @impl true
  def init({channel_id, spacer}), do: {:ok, build_state(channel_id, spacer)}

  @impl true
  def handle_info(:run, %{cats: cats} = state) do
    if cats |> Enum.map(&Enum.count(&1)) |> Enum.sum() == 0 do
      message = Enum.map(1..4, &"#{&1}. :cat:\n") |> List.to_string()

      send_message_with_header(state.id, message)

      {:stop, :normal, state}
    else
      message =
        cats
        |> Enum.reject(&Enum.empty?(&1))
        |> Enum.map(&([":checkered_flag:"] ++ &1 ++ ".\n"))
        |> List.to_string()

      cats =
        Enum.map(cats, fn x ->
          {index, max} =
            if x |> Enum.at(1) == @cat do
              {1, 1}
            else
              {:rand.uniform(2), Enum.count(x) - 1}
            end

          Enum.slice(x, index..max)
        end)

      state = %{state | cats: cats}

      send_message_with_header(state.id, message)

      schedule_next_job()
      {:noreply, state}
    end
  end

  defp send_message_with_header(channel_id, message),
    do: Client.send_message(channel_id, @header <> "\n" <> message)

  defp schedule_next_job() do
    Process.send_after(self(), :run, 5000)
  end

  defp build_state(channel_id, spacer) do
    %{
      id: channel_id,
      cats: build_cats(spacer)
    }
  end

  defp build_cats(spacer) do
    Enum.map(1..4, fn _ ->
      [@cat | Enum.map(1..10, fn _ -> spacer end)]
      |> Enum.reverse()
    end)
  end

  def start_link(channel_id, spacer) do
    GenServer.start_link(__MODULE__, {channel_id, spacer})
  end

  def run(pid) do
    Kernel.send(pid, :run)
  end
end
