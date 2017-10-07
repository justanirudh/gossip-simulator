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
    # flush()
    num = Enum.at(args, 0) |> String.to_integer
    topo = Enum.at(args, 1)
    algo = Enum.at(args, 2)

    # IO.inspect self()
    
    self() |> Process.register(:master) #register master
    {nodes, num} = Topology.create(num, topo, algo) #create topology
    # IO.inspect nodes
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
    # IO.inspect thresh * num |> round
    :ok = loop(thresh * num |> round)#loop till master receives num number of successes
    # :ok = loop_debug(thresh * num |> round, nodes)#TODO remove this, for debugging
    next = System.monotonic_time(:microsecond)
    IO.puts "#{next - prev}"
    #TODO: throws here as master dies after a child has sent a message and before the master receives it. Fix this


    ######################################
    # topo = "full"
    # algo = "gossip"
    # start = 2
    # lim = 16385 full ,line
    # thresh = 0.50
    # # lim = 34970 2d, imp2d 
    # test_values(topo, algo, start, lim, thresh)

  end 
  
end
#GossipSimulator.start