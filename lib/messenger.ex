defmodule Messenger do
    use GenServer

    def spread_rumor(neighbours, num_neighbours) do
        Enum.at(neighbours, :rand.uniform(num_neighbours) - 1) |> GenServer.cast(:rumor)
        spread_rumor(neighbours, num_neighbours)
    end

    def init(state) do
        {:ok, state}
    end
end