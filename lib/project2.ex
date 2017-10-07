defmodule GossipSimulator do

  defp loop(num) do
    case num do
        0 -> :ok
        _ ->
            receive do
                :success -> loop(num - 1)
            end
    end
  end

  def main(args) do
    num = Enum.at(args, 0) |> String.to_integer
    topo = Enum.at(args, 1)
    algo = Enum.at(args, 2)

    self() |> Process.register(:master) #register master
    {nodes, num} = Topology.create(num, topo, algo) #create topology
    first = Enum.at(nodes, :rand.uniform(num) - 1) # pick a random node [0, num - 1]
    prev = System.monotonic_time(:microsecond) #start timer
    limit = case algo do
       "gossip" -> 
          GenServer.cast(first, :rumor) #spread the rumor
          0.5 * num |> round
       "push-sum" -> 
          GenServer.cast(first, :start) #spread the rumor
          case topo do
             "line" -> 0.5 * num |> round
             "2D" -> 1
              _ -> 0.75 * num |> round
          end
    end
    :ok = loop(limit)
    next = System.monotonic_time(:microsecond)
    IO.puts "#{next - prev} microseconds"

  end 
end