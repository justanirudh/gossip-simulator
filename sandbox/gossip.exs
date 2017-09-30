
defmodule Node do
    use GenServer
    @heard 10
    #initial state: {empty array,count = 0} 

    def handle_call({:neighbours, neighbours}, _from, old_state) do
      {:reply, :ok, {neighbours, 0}} # reply atom, actual reply, new_state
    end

    def handle_call(:show_neighbours, _from, state) do
      {:reply, elem(state, 0), state} 
    end

    #1 increment count
    #2 check if count == heard
    #3 if count != heard
        #1 select a random neighbour from neighbours
        #2 send it the rumor
    #4 if count == heard
        #1 send master process the success info  
    def handle_call(:rumor, _from, state) do
        IO.inspect _from


    end

    def handle_info(_msg, state) do #catch unexpected messages
        {:noreply, state}
    end

end

defmodule GossipSim do

    def sendNeighbours(:full, list, index, size) do
        if(index != size) do
            server = Enum.at(list, index)    
            neighbours = List.delete(list, server)
            :ok = GenServer.call(server, {:neighbours, neighbours})
            # ns = GenServer.call(server, :show_neighbours)
            # IO.inspect server
            # IO.inspect ns
            sendNeighbours(:full, list, index + 1, size)
        else
            #NOP
        end
    end
    
    #create topology (spawn num processes, send data (each node's neighbors) to each node)
    def create_topology(num, topo, algo) do
        #1 spawn processes
        list = 1..num |> Enum.map(fn _ -> elem(GenServer.start_link(Node, {[], 0}), 1) end)
        #2 send info of neighbors to each process spawned before
        case topo do
            "full" -> sendNeighbours(:full, list, 0, length(list))
            _ -> raise "Not supported"
        end
        list
    end   
end

#create topology
num = 10
topo = "full"
algo = "gossip"
nodes = GossipSim.create_topology(num, topo, algo);
#pick a random node [0, num - 1] and spread the rumor
first = Enum.at(nodes, :rand.uniform(num) - 1)
#TODO: start timer here
GenServer.call(first, :rumor)
#loop till master receives num number of successes
#then stop timer and calculate time elapsed
