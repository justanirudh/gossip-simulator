defmodule GossipSimulator do

  # defp loop(num) do
  #   case num do
  #       0 -> :ok
  #       _ ->
  #           receive do
  #               :success -> loop(num - 1)
  #           end
  #   end
  # end

  defp loop_debug(num, list) do
    case num do
        0 -> :ok
        _ ->
            receive do
                :success -> 
                  loop_debug(num - 1, list)
                {:first_signal, sender} ->
                  plotty_index = Enum.find_index(list, fn(x) -> x == sender end) + 1
                  IO.puts "<plotty: infected, #{plotty_index}>"
                  loop_debug(num, list)
                {:inactive, sender} ->
                  plotty_index = Enum.find_index(list, fn(x) -> x == sender end) + 1
                  IO.puts "<plotty: inactive, #{plotty_index}>"
                  loop_debug(num, list)
            end
    end
  end

  def main(args) do
    IO.inspect Enum.at(args, 1)
    num = Enum.at(args, 0) |> String.to_integer
    topo = Enum.at(args, 1)
    algo = Enum.at(args, 2)
    
    #register master
    self() |> Process.register(:master)
    #create topology
    nodes = Topology.create(num, topo, algo);
    # pick a random node [0, num - 1] 
    first = Enum.at(nodes, :rand.uniform(num) - 1)
    #TODO: start timer here
    case algo do
       "gossip" -> GenServer.cast(first, :rumor) #spread the rumor
       "push-sum" -> GenServer.cast(first, :start) #spread the rumor       
    end
    
    # :ok = loop(num)#loop till master receives num number of successes
    :ok = loop_debug(num, nodes)#TODO remove this, for debugging
    IO.puts "All nodes converged"
    #TODO: stop timer  
  end
  
end
#GossipSimulator.start