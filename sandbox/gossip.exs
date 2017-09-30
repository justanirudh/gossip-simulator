
defmodule Node do
    use GenServer
  
    ### GenServer API
  
    @doc """
    GenServer.handle_call/3 callback
    """
    def handle_call({:neighbours, neighbours}, _from, []) do
      {:reply, :ok, neighbours} # reply atom, actual reply, new_state
    end

    def handle_call(:show_neighbours, _from, neighbours) do
      {:reply, neighbours, neighbours} # reply atom, actual reply, new_state
    end

    def handle_info(_msg, state) do
        {:noreply, state}
    end

end

defmodule GossipSim do

    def sendNeighbours(:full, list, index, size) do
        if(index != size) do
            server = Enum.at(list, index)    
            neighbours = List.delete(list, server)
            :ok = GenServer.call(server, {:neighbours, neighbours})
            ns = GenServer.call(server, :show_neighbours)
            IO.inspect server
            IO.inspect ns
            sendNeighbours(:full, list, index + 1, size)
        else
            #NOP
        end
    end
    
    #create topology (spawn 100 processes, send data of each node's neighbor to each node)
    def create_topology(size, topo, algo) do
        #1 spawn processes
        list = 1..size |> Enum.map(fn _ -> elem(GenServer.start_link(Node, []), 1) end)
        #2 send info of neighbors to each process spawned before
        case topo do
            "full" -> sendNeighbours(:full, list, 0, length(list))
            _ -> raise "Not supported"
        end

    end

    
end

GossipSim.create_topology(10, "full", "gossip");
