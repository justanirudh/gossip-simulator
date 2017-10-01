defmodule Topology do

    defp get_line_neighbours(list, index, num) do
        if index == 0 do
            [Enum.at(list, 1)]
        else
            if index == num - 1 do
                [Enum.at(list, num - 2)]
            else
                [Enum.at(list, index - 1), Enum.at(list, index + 1)]            
            end
        end
    end

    defp get_full_neighbours(list, server) do
        List.delete(list, server)
    end

    defp send_data(list, index, num, topo) do
        if(index != num) do
            server = Enum.at(list, index)
            neighbours = case topo do
                :full -> get_full_neighbours(list, server)
                :line -> get_line_neighbours(list, index, num)
                _ -> raise topo <> " not supported"  
            end                
            :ok = GenServer.call(server, {:neighbours, neighbours})
            # ns = GenServer.call(server, :show_neighbours)
            # IO.inspect server
            # IO.inspect ns
            send_data(list, index + 1, num, topo)
        else
            :ok
        end
    end
    
    
    def create(num, topo, algo) do
        #1 spawn processes
        list = 1..num |> Enum.map(fn _ -> elem(GenServer.start_link(Gossiper, []), 1) end)
        #2 send info of neighbors to each process spawned before
        case topo do
            "full" -> :ok = send_data(list, 0, num, :full)
            "line" -> :ok = send_data(list, 0, num, :line)
             _ -> raise "Not supported"
        end
        list
    end
end