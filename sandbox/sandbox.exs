defmodule Sandbox do
    use GenServer
    #first call to setup the node
    def handle_call(:stop, _from, st) do
        curr = self
        Process.exit(curr, "All nodes heard the rumor at least 10 times")   
        {:reply, :ok, st} # reply atom, actual reply, new_state
    end
end
{:ok, pid} = GenServer.start_link(Sandbox, [])
GenServer.call(pid, :stop)