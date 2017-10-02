defmodule Gossiper do
    use GenServer
    @heard 10
    #state: {neighbours, neighbours_size, number of times heard, child pid} 

    def spread_rumor(neighbours, num_neighbours) do
        Enum.at(neighbours, :rand.uniform(num_neighbours) - 1) |> GenServer.cast(:rumor)
        # IO.puts "spread the rumor"
        :timer.sleep(100)
        spread_rumor(neighbours, num_neighbours)
    end

    #first call to setup the node
    def handle_call({:neighbours, neighbours}, _from, _) do
      {:reply, :ok, {neighbours, length(neighbours), 0, nil}} # reply atom, actual reply, new_state
    end

    #for debugging
    def handle_call(:show_neighbours, _from, state) do
      {:reply, elem(state, 0), state} 
    end

    #for debugging
    defp print(str) do
        curr = self()
        IO.inspect curr
        IO.puts str
    end

    #TODO: Check if termination condition is green or orange (mostly green, so change that)
    def handle_cast(:rumor, state) do
        if(state != :inactive) do #node is active
            neighbours = elem(state, 0)
            num_neighbours = elem(state, 1)
            count = elem(state, 2)
            pid = elem(state, 3)
            count = count + 1; #increment number of times heard rumor
            # print("got the rumor. Its count is #{count}")
            curr = self() #TODO for debugging
            if count == @heard do #count reached @heard
                # send pid, :stop
                # IO.inspect pid
                # Task.shutdown(pid)
                # IO.inspect Process.alive?(pid)
                Process.exit(pid, :kill)
                # IO.inspect Process.alive?(pid)    
                # IO.puts "task shutdown"
                # print("became inactive")
                send Process.whereis(:master), {:inactive, curr} #TODO for debugging
                send Process.whereis(:master), :success #send master success; TODO: there should not be any master?
                {:noreply, :inactive}
            else #count hasnt reached @heard
                if count == 1 do #when it gets the first signal
                    send Process.whereis(:master), {:first_signal, curr} #TODO for debugging              
                    pid = spawn(fn -> __MODULE__.spread_rumor(neighbours, num_neighbours) end) #continuously spread the rumor  
                    #state now: {neighbours, neighbours_size, number of times heard, pid of child process}    
                    {:noreply, {neighbours, num_neighbours, 1, pid}} #add PID to state
                else  #count is incrementing to reach @heard
                    {:noreply, {neighbours, num_neighbours, count, pid}}
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