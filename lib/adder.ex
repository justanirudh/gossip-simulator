defmodule Adder do
    use GenServer
    @diff 1.0e-10
    @round_lim 3
    #state: {neighbours, neighbours_size, s, w, rounds, child pid} 
  
    #for debugging
    defp print(str) do
        curr = self()
        IO.inspect curr
        IO.puts str
    end

    def spread_pushsum(neighbours, num_neighbours, s, w) do
        Enum.at(neighbours, :rand.uniform(num_neighbours) - 1) |> GenServer.cast({:pushsum, s, w})
        # IO.puts "spread the sum"
        :timer.sleep(100)
        spread_pushsum(neighbours, num_neighbours, s, w)
    end
    
    defp kill_and_replay(child_pid, neighbours, num_neighbours, s, w) do
        if(child_pid != nil) do
            Process.exit(child_pid, :kill) #kill previous spreader    
        end
        spawn(fn -> __MODULE__.spread_pushsum(neighbours, num_neighbours, s, w) end) #continuously spread the rumor   
    end

    #for debugging
    def handle_call(:show_neighbours, _from, state) do
        {:reply, elem(state, 0), state} 
    end

    #first call to setup the neighbours
    def handle_call({:neighbours, neighbours}, _from, s) do
        {:reply, :ok, {neighbours, length(neighbours), s, 1, 0, nil}} # reply atom, actual reply, new_state
    end

    #first call to start the pushsum algo
    def handle_cast(:start, state) do
        neighbours = elem(state, 0)
        num_neighbours = elem(state, 1)
        s = elem(state, 2)
        w = elem(state, 3)
        
        child_pid = kill_and_replay(nil, neighbours, num_neighbours, s/2, w/2)
        {:noreply, {neighbours, num_neighbours, s/2, w/2, elem(state, 4), child_pid}} #pass s/2, w/2
    end

    def handle_cast({:pushsum, s, w}, state) do
        if(state != :inactive) do
            neighbours = elem(state, 0)
            num_neighbours = elem(state, 1)
            old_s = elem(state, 2)
            old_w = elem(state, 3)
            rounds = elem(state, 4)
            child_pid = elem(state, 5)

            curr = self() #TODO for debugging
            if child_pid == nil do #TODO: remove this, for debugging
                #first call: active and child pid is nill, hence first call
                send Process.whereis(:master), {:first_signal, curr} #TODO for debugging 
            end
            old_ratio = old_s/old_w
            new_s = old_s + s
            new_w = old_w + w
            new_ratio = new_s/new_w
            if(abs(new_ratio - old_ratio) <= @diff) do
                rounds = rounds + 1
                if(rounds == @round_lim) do
                    if(child_pid != nil) do
                        Process.exit(child_pid, :kill) #kill previous spreader    
                    end
                    send Process.whereis(:master), {:inactive, curr} #TODO for debugging
                    send Process.whereis(:master), :success #send master success
                    IO.inspect new_ratio #TODO for debugging
                    {:noreply, :inactive}
                else
                    child_pid = kill_and_replay(child_pid, neighbours, num_neighbours, new_s/2, new_w/2)
                    {:noreply, {neighbours, num_neighbours, new_s/2, new_w/2, rounds, child_pid}} #pass s/2, w/2
                end               
            else
                child_pid = kill_and_replay(child_pid, neighbours, num_neighbours, new_s/2, new_w/2)
                {:noreply, {neighbours, num_neighbours, new_s/2, new_w/2, 0, child_pid}} #if not consec <= diff, rounds back to 0        
            end
        else
            {:noreply, :inactive}
        end
    end 

    def handle_info(_msg, state) do #catch unexpected messages
        {:noreply, state}
    end
    
end