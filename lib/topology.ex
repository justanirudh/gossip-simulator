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

    defp get_twoD_neighbours(list, index, num) do
        side = num |> :math.sqrt |> round
        row = div(index, side)
        col = rem(index, side)
        res = []

        up_row = row - 1
        if(up_row >= 0) do
            res = [ Enum.at(list, (up_row * side) + col) | res]        
        end         
        down_row = row + 1
        if(down_row < side) do
            res = [ Enum.at(list, (down_row * side) + col)  | res]
        end    
        left_col = col - 1
        if left_col >= 0 do
            res = [ Enum.at(list, (row * side) + left_col) | res]
        end
        right_col = col + 1
        if right_col < side do
            res = [ Enum.at(list, (row * side) + right_col) | res]
        end
        res   
    end

    defp get_impTwoD_neighbours(list, index, num, server) do
        ns = get_twoD_neighbours(list, index, num)
        #remove 4 neighbours and itself from the space
        space_left = get_full_neighbours(list,server) -- ns 
        #select a random element from left space
        fifth =  Enum.at(space_left, :rand.uniform(length(space_left)) - 1)
        [fifth | ns]
    end    


    defp send_data(list, index, num, topo) do
        if(index != num) do
            server = Enum.at(list, index)
            neighbours = case topo do
                :full -> get_full_neighbours(list, server)
                :line -> get_line_neighbours(list, index, num)
                :twoD -> get_twoD_neighbours(list, index, num)
                :impTwoD -> get_impTwoD_neighbours(list, index, num, server)
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
        #2 send info of neighbors to each process spawned before
        
        num = 
            case topo do
                "full" -> num
                "line" -> num
                "2D" -> num |> :math.sqrt |> round |> :math.pow(2) |> round #TODO: always round up?
                "imp2D" -> num |> :math.sqrt |> round |> :math.pow(2) |> round
                _ -> raise "Not supported"     
            end

        #TODO remove this
        # IO.puts "<plotty: draw, #{num}>"
        
        list = 
            case algo do
                "gossip" -> 1..num |> Enum.map(fn _ -> elem(GenServer.start_link(Gossiper, []), 1) end)
                "push-sum" -> 1..num |> Enum.map(fn i -> elem(GenServer.start_link(Adder, i), 1) end) #i = s
                _ -> raise "Not supported"
            end

        case topo do
            "full" -> :ok = send_data(list, 0, num, :full)
            "line" -> :ok = send_data(list, 0, num, :line)
            "2D" -> :ok = send_data(list, 0, num, :twoD)
            "imp2D" -> :ok = send_data(list, 0, num, :impTwoD)
        end
        {list, num}
    end
end