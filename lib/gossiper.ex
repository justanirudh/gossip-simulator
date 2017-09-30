defmodule Gossiper do
    use GenServer
    @heard 10
    #state: {neighbours, neighbours_size, number of times heard} 

    #first call to setup the node
    def handle_call({:neighbours, neighbours, len}, _from, old_state) do
      {:reply, :ok, {neighbours, len, 0}} # reply atom, actual reply, new_state
    end

    #for debugging
    def handle_call(:show_neighbours, _from, state) do
      {:reply, elem(state, 0), state} 
    end

    #1 increment count
    #2 check if count == heard
    #3 if count != heard
        #1 select a random neighbour from neighbours
        #2 send it the rumor
    #4 if count == heard
        #1 send master process the success info  
    def handle_cast(:rumor, state) do
        count = elem(state, 2) + 1; #increment number of times heard rumor
        # IO.puts
        IO.inspect self()
        IO.puts "got the rumor. Its count is #{count}"
        if count == @heard do
            send Process.whereis(:master), :success #send master success; TODO: there should not be any master 
            #TODO: make this inactive? 
        end
            
        Enum.at(elem(state, 0), :rand.uniform(elem(state,1)) - 1) |> GenServer.cast(:rumor)
        {:noreply, {elem(state, 0), elem(state, 1), count}}
    end

    def handle_info(_msg, state) do #catch unexpected messages
        {:noreply, state}
    end

end