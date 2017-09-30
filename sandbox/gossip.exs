
defmodule Node do
    use GenServer
    @heard 10
    #state: {neighbours, neighbours_size, number of times heard} 

    #first call to setup the node
    def handle_call({:neighbours, neighbours, len}, _from, old_state) do
      {:reply, :ok, {neighbours, len, 0}} # reply atom, actual reply, new_state
    end

    #for debugging
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
    def handle_cast(:rumor, state) do
        count = elem(state, 2) + 1; #increment number of times heard rumor
        # IO.puts
        IO.inspect self()
        IO.puts "got the rumor. Its count is #{count}"
        if count == @heard do
            send Process.whereis(:master), :success #send master success 
        end    
        Enum.at(elem(state, 0), :rand.uniform(elem(state,1)) - 1) |> GenServer.cast(:rumor)
            # neigbours =   elem(state, 0)
            # IO.inspect neigbours
            # rand_index = :rand.uniform(elem(state,1)) - 1
            # IO.inspect rand_index
            # pid = Enum.at(neigbours, rand_index)
            # IO.inspect pid
            # GenServer.cast(pid, :rumor)    
        
        {:noreply, {elem(state, 0), elem(state, 1), count}}
    end

    def handle_info(_msg, state) do #catch unexpected messages
        {:noreply, state}
    end

end

defmodule GossipSim do

    defp send_data(:full, list, index, num) do
        if(index != num) do
            server = Enum.at(list, index)    
            neighbours = List.delete(list, server)
            num_neighbours = length(neighbours)
            :ok = GenServer.call(server, {:neighbours, neighbours, num_neighbours})
            # ns = GenServer.call(server, :show_neighbours)
            # IO.inspect server
            # IO.inspect ns
            send_data(:full, list, index + 1, num)
        else
            #NOP
        end
    end
    
    #create topology (spawn num processes, send data (each node's neighbors) to each node)
    def create_topology(num, topo, algo) do
        #1 spawn processes
        list = 1..num |> Enum.map(fn _ -> elem(GenServer.start_link(Node, {[], 0, 0}), 1) end)
        #2 send info of neighbors to each process spawned before
        case topo do
            "full" -> send_data(:full, list, 0, num)
            _ -> raise "Not supported"
        end
        list
    end
    
    def loop(num) do
        case num do
            0 -> :ok
            _ ->
                receive do
                    :success -> loop(num - 1)
                end
        end
    end
end

#create topology
num = 10
topo = "full"
algo = "gossip"
#register master
self() |> Process.register(:master)
#create topology
nodes = GossipSim.create_topology(num, topo, algo);
#pick a random node [0, num - 1] 
first = Enum.at(nodes, :rand.uniform(num) - 1)
#TODO: start timer here
GenServer.cast(first, :rumor)#spread the rumor
:ok = GossipSim.loop(num)#loop till master receives num number of successes
IO.inspect "All nodes heard the rumor at least 10 times"
#stop timer