defmodule Sandbox do
    use GenServer

    def spread_rumor() do
        IO.puts "hello"
        # receive do
        #     {:message_type, value} -> IO.puts "hmm"
        #     # code
        # end
        spread_rumor
    end

    def spread_rumor2() do
        IO.puts "hi"
        # receive do
        #     {:message_type, value} -> IO.puts "hmm"
        #     # code
        # end
        spread_rumor2
    end

    def handle_call(:start, _from, st) do
        t = Task.async(fn -> __MODULE__.spread_rumor end)
        # t = Task.async(__MODULE__, spread_rumor, [])
        {:reply, :ok, t} # reply atom, actual reply, new_state
    end

    #first call to setup the node
    def handle_call(:stop, _from, st) do
        IO.inspect st
        # Process.exit(st[:pid], "stop please")
        Task.shutdown(st, :brutal_kill)
        IO.puts "still runs after killing child"
        {:reply, :ok, nil} # reply atom, actual reply, new_state
    end
end
{:ok, pid} = GenServer.start_link(Sandbox, [])
GenServer.call(pid, :start)
GenServer.call(pid, :stop)
# Sandbox.spread_rumor2