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
      {:reply, :ok, {neighbours, length(neighbours), 0, nil}}
    end

    def handle_cast(:rumor, state) do
        if(state != :inactive) do #node is active
            neighbours = elem(state, 0)
            num_neighbours = elem(state, 1)
            count = elem(state, 2)
            child_pid = elem(state, 3)
            curr = self() #TODO for debugging
            master_pid = Process.whereis(:master)
            
            count = count + 1 #increment number of times heard rumor
            if count == @heard do #count reached @heard
                Task.shutdown(child_pid, :brutal_kill)
                # IO.puts Process.alive?(child_pid.pid)
                if(master_pid != nil) do #required if master dies after getting all successes
                    # send master_pid, {:inactive, curr} #TODO for debugging
                    # IO.inspect curr
                    # send master_pid, :success #send master success    
                end
                {:noreply, :inactive}
            else #count hasn't reached @heard
                if count == 1 do #when it gets the first signal
                    if(master_pid != nil) do    
                        # send Process.whereis(:master), {:first_signal, curr} #TODO for debugging 
                        send master_pid, :success #send master success               
                    end
                    child_pid = Task.async(fn -> __MODULE__.spread_rumor(neighbours, num_neighbours) end) #continuously spread the rumor  
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