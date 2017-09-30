defmodule Gossiper do
    use GenServer
    @heard 10
    #state: {neighbours, neighbours_size, number of times heard} 

    def spread_rumor(neighbours, num_neighbours) do
        Enum.at(neighbours, :rand.uniform(num_neighbours) - 1) |> GenServer.cast(:rumor)
        spread_rumor(neighbours, num_neighbours)
    end

    #first call to setup the node
    def handle_call({:neighbours, neighbours, len}, _from, state) do
      {:reply, :ok, {neighbours, len, elem(state, 2)}} # reply atom, actual reply, new_state
    end

    #for debugging
    def handle_call(:show_neighbours, _from, state) do
      {:reply, elem(state, 0), state} 
    end

    #for debugging
    def print(str) do
        curr = self()
        IO.inspect curr
        IO.puts str
    end

    def handle_cast(:rumor, state) do
        if(state != :inactive) do
            count = elem(state, 2) + 1; #increment number of times heard rumor
            print("got the rumor. Its count is #{count}")
            if count == @heard do
                send Process.whereis(:master), :success #send master success; TODO: there should not be any master?
                print("became inactive")
                {:noreply, :inactive}
            else    
                neighbours = elem(state, 0)
                num_neighbours = elem(state, 1)
                if count == 1 do #when it gets the first signal                    
                    Task.start_link(__MODULE__, :spread_rumor, [neighbours, num_neighbours]) #continuously spread the rumor     
                end 
                {:noreply, {neighbours, num_neighbours, count}}
            end
        else
            {:noreply, :inactive}
        end
    end

    def handle_info(_msg, state) do #catch unexpected messages
        {:noreply, state}
    end

end