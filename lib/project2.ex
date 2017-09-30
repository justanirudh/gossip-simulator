defmodule GS do
#TODO: chnage name to GossipSimulator
  def start() do
    num = 10
    topo = "full"
    algo = "gossip"
    #register master
    self() |> Process.register(:master)
    #create topology
    nodes = Utils.create_topology(num, topo, algo);
    #pick a random node [0, num - 1] 
    first = Enum.at(nodes, :rand.uniform(num) - 1)
    #TODO: start timer here
    GenServer.cast(first, :rumor)#spread the rumor
    :ok = Utils.loop(num)#loop till master receives num number of successes
    Process.exit(self(), "All nodes heard the rumor 10 times")
    #TODO: stop timer  
  end
  
end
#GossipSimulator.start