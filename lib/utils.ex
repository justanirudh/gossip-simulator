defmodule Utils do

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
            :ok
        end
    end
    
    #create topology (spawn num processes, send data (each node's neighbors) to each node)
    def create_topology(num, topo, algo) do
        #1 spawn processes
        list = 1..num |> Enum.map(fn _ -> elem(GenServer.start_link(Gossiper, {[], 0, 0}), 1) end)
        #2 send info of neighbors to each process spawned before
        case topo do
            "full" -> :ok = send_data(:full, list, 0, num)
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