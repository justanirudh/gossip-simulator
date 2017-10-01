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
    num = 9
    topo = "2D"
    algo = "gossip"
    
    #TODO remove this
    IO.puts "<plotty: draw, #{num}>"

    #register master
    self() |> Process.register(:master)
    #create topology
    nodes = Topology.create(num, topo, algo);
    # pick a random node [0, num - 1] 
    # first = Enum.at(nodes, :rand.uniform(num) - 1)
    # #TODO: start timer here
    # GenServer.cast(first, :rumor)#spread the rumor
    # # :ok = loop(num)#loop till master receives num number of successes
    # :ok = loop_debug(num, nodes)#TODO remove this, for debugging
    # IO.puts "All nodes heard the rumor n times"
    # #TODO: stop timer  
  end
  
end
#GossipSimulator.start