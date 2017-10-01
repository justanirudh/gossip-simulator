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
    num = 1000
    topo = "line"
    algo = "gossip"
    #register master
    self() |> Process.register(:master)
    #create topology
    nodes = Topology.create(num, topo, algo);
    # pick a random node [0, num - 1] 
    first = Enum.at(nodes, :rand.uniform(num) - 1)
    #TODO: start timer here
    GenServer.cast(first, :rumor)#spread the rumor
    :ok = loop(num)#loop till master receives num number of successes
    Process.exit(self(), "All nodes heard the rumor 10 times")
    #TODO: stop timer  
  end
  
end
#GossipSimulator.start