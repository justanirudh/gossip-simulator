defmodule Gossiper do
    use GenServer
    @heard 10
    #state: {neighbours, neighbours_size, number of times heard} 

    def spread_rumor(neighbours, num_neighbours) do
        Enum.at(neighbours, :rand.uniform(num_neighbours) - 1) |> GenServer.cast(:rumor)
        curr = self();
        send curr, :continue
        receive do
            :continue -> spread_rumor(neighbours, num_neighbours)
            :stop -> 
                IO.puts "task stopped"
                :ok
        end
    end

    #first call to setup the node
    def handle_call({:neighbours, neighbours}, _from, _) do
      {:reply, :ok, {neighbours, length(neighbours), 0}} # reply atom, actual reply, new_state
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

    def handle_cast(:rumor, state) do
        if(state != :inactive) do
            count = elem(state, 2) + 1; #increment number of times heard rumor
            print("got the rumor. Its count is #{count}")
            curr = self() #TODO remove this, for debugging
            if count == @heard do
                # send elem(state, 3), :stop
                t = elem(state, 3)
                IO.inspect t
                Task.shutdown(t)
                IO.puts "task shutdown"
                print("became inactive")
                send Process.whereis(:master), {:inactive, curr} #TODO remove this, for debugging
                send Process.whereis(:master), :success #send master success; TODO: there should not be any master?
                {:noreply, :inactive}
            else
                neighbours = elem(state, 0)
                num_neighbours = elem(state, 1)
                if count == 1 do #when it gets the first signal
                    send Process.whereis(:master), {:first_signal, curr} #TODO remove this; for debugging              
                    t = Task.async(fn -> __MODULE__.spread_rumor(neighbours, num_neighbours) end) #continuously spread the rumor     
                    {:noreply, {neighbours, num_neighbours, count, t}} #add PID to state
                else    
                    {:noreply, {neighbours, num_neighbours, count, elem(state, 3)}}
                end 
                
            end
        else
            #TODO: sleep here to not consume CPU cycles?
            {:noreply, :inactive}
        end
    end

    def handle_info(_msg, state) do #catch unexpected messages
        {:noreply, state}
    end

end