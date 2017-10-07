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

  # defp loop_debug(num, list) do
  #   case num do
  #       0 -> :ok
  #       _ ->
  #           receive do
  #               :success ->
  #                 IO.inspect num 
  #                 loop_debug(num - 1, list)
  #               {:first_signal, sender} ->
  #                 plotty_index = Enum.find_index(list, fn(x) -> x == sender end) + 1
  #                 IO.puts "<plotty: infected, #{plotty_index}>"
  #                 loop_debug(num, list)
  #               {:inactive, sender} ->
  #                 # IO.inspect sender
  #                 # IO.inspect list
  #                 plotty_index = Enum.find_index(list, fn(x) -> x == sender end) + 1
  #                 IO.puts "<plotty: inactive, #{plotty_index}>"
  #                 loop_debug(num, list)
  #           end
  #   end
  # end

  def main(args) do
    num = Enum.at(args, 0) |> String.to_integer
    topo = Enum.at(args, 1)
    algo = Enum.at(args, 2)

    self() |> Process.register(:master) #register master
    {nodes, num} = Topology.create(num, topo, algo) #create topology
    first = Enum.at(nodes, :rand.uniform(num) - 1) # pick a random node [0, num - 1]
    prev = System.monotonic_time(:microsecond) #start timer
    thresh = case algo do
       "gossip" -> 
          GenServer.cast(first, :rumor) #spread the rumor
          0.5
       "push-sum" -> 
          GenServer.cast(first, :start) #spread the rumor
          0.75
    end 
    :ok = loop(thresh * num |> round)
    # :ok = loop_debug(thresh * num |> round, nodes)#TODO remove this, for debugging
    next = System.monotonic_time(:microsecond)
    IO.puts "#{next - prev}"

  end 
end