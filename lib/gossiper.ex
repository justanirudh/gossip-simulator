defmodule Gossiper do
    use GenServer
    @heard 10
    #state: {neighbours, neighbours_size, number of times heard, child pid} 
  
    #for debugging
    defp print(str) do
        curr = self()
        IO.inspect curr
        IO.puts str
    end

    def spread_rumor(neighbours, num_neighbours) do
        Enum.at(neighbours, :rand.uniform(num_neighbours) - 1) |> GenServer.cast(:rumor)
        # IO.puts "spread the rumor"
        :timer.sleep(100)
        spread_rumor(neighbours, num_neighbours)
    end

    #for debugging
    def handle_call(:show_neighbours, _from, state) do
        {:reply, elem(state, 0), state} 
    end

    #first call to setup the node
    def handle_call({:neighbours, neighbours}, _from, _) do
      {:reply, :ok, {neighbours, length(neighbours), 0, nil}} # reply atom, actual reply, new_state
    end

    #TODO: Check if termination condition is green or orange (mostly green, so change that)
    def handle_cast(:rumor, state) do
        if(state != :inactive) do #node is active
            neighbours = elem(state, 0)
            num_neighbours = elem(state, 1)
            count = elem(state, 2)
            child_pid = elem(state, 3)
            count = count + 1 #increment number of times heard rumor
            curr = self() #TODO for debugging
            if count == @heard do #count reached @heard
                Process.exit(child_pid, :kill)
                # send Process.whereis(:master), {:inactive, curr} #TODO for debugging
                send Process.whereis(:master), :success #send master success
                {:noreply, :inactive}
            else #count hasnt reached @heard
                if count == 1 do #when it gets the first signal
                    # send Process.whereis(:master), {:first_signal, curr} #TODO for debugging              
                    child_pid = spawn(fn -> __MODULE__.spread_rumor(neighbours, num_neighbours) end) #continuously spread the rumor  
                    #state now: {neighbours, neighbours_size, number of times heard, pid of child process}  
                    # send Process.whereis(:master), :success #send master success  
                    {:noreply, {neighbours, num_neighbours, 1, child_pid}} #add PID to state
                else  #gets non-first signal
                    {:noreply, {neighbours, num_neighbours, count, child_pid}}
                end   
            end
        else #node is inactive
            {:noreply, :inactive}
        end
    end

    def handle_info(_msg, state) do #catch unexpected messages
        {:noreply, state}
    end

end