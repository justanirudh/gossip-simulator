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
        # t = Task.async(fn -> __MODULE__.spread_rumor end)
        t = spawn(fn -> __MODULE__.spread_rumor end)
        # t = Task.async(__MODULE__, spread_rumor, [])
        {:reply, :ok, t} # reply atom, actual reply, new_state
    end

    #first call to setup the node
    def handle_call(:stop, _from, st) do
        IO.inspect st
        # Process.exit(st[:pid], "stop please")
        # Task.shutdown(st, :brutal_kill)
        Process.exit(st, :kill)
        IO.puts "still runs after killing child"
        {:reply, :ok, nil} # reply atom, actual reply, new_state
    end
end
# foo = Sandbox
foo = Bar
IO.inspect foo
{:ok, pid} = GenServer.start_link(foo, [])
GenServer.call(pid, :start)
# :timer.sleep 100
GenServer.call(pid, :stop)
# Sandbox.spread_rumor2
foo = [29000,
100520000,
201796000,
302740000,
504735000,
505365000,
707572000,
808655000,
1009910000,
828229000,
1840938000,
1183075000,
5632767000,
87374755000]