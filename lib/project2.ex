defmodule GossipSimulator do

  defp loop(num) do
    case num do
        0 -> :ok
        _ ->
            receive do
                :success -> loop(num - 1)
            end
    end
  end

  # defp loop_debug(num, list) do
  #   case num do
  #       0 -> :ok
  #       _ ->
  #           receive do
  #               :success -> 
  #                 loop_debug(num - 1, list)
  #               {:first_signal, sender} ->
  #                 plotty_index = Enum.find_index(list, fn(x) -> x == sender end) + 1
  #                 IO.puts "<plotty: infected, #{plotty_index}>"
  #                 loop_debug(num, list)
  #               {:inactive, sender} ->
  #                 plotty_index = Enum.find_index(list, fn(x) -> x == sender end) + 1
  #                 IO.puts "<plotty: inactive, #{plotty_index}>"
  #                 loop_debug(num, list)
  #           end
  #   end
  # end


  # def test_values(topo, algo, num, lim, thresh) do
  #   if num < lim do
  #     {nodes, num} = Topology.create(num, topo, algo);
  #     first = Enum.at(nodes, :rand.uniform(num) - 1)
  #     prev = System.monotonic_time()
  #     case algo do
  #        "gossip" -> GenServer.cast(first, :rumor) #spread the rumor
  #        "push-sum" -> GenServer.cast(first, :start) #spread the rumor       
  #     end
  #     :ok = loop(thresh * num |> round)#loop till master receives num number of successes
  #     next = System.monotonic_time()
  #     IO.puts "#{next - prev}"
  #     test_values(topo, algo, num * 2, lim, thresh)
  #   else
  #     :ok
  #   end   
  # end

  def main(args) do
    num = Enum.at(args, 0) |> String.to_integer
    topo = Enum.at(args, 1)
    algo = Enum.at(args, 2)
    
    #register master
    self() |> Process.register(:master)
    #create topology
    {nodes, num} = Topology.create(num, topo, algo);
    # pick a random node [0, num - 1] 
    first = Enum.at(nodes, :rand.uniform(num) - 1)
    prev = System.monotonic_time(:millisecond)
    thresh = case algo do
       "gossip" -> 
          GenServer.cast(first, :rumor) #spread the rumor
          0.5
       "push-sum" -> 
          GenServer.cast(first, :start) #spread the rumor
          0.75
    end 
    :ok = loop(thresh * num |> round)#loop till master receives num number of successes
    # :ok = loop_debug(num, nodes)#TODO remove this, for debugging
    next = System.monotonic_time(:millisecond)
    IO.puts "#{next - prev} miliseconds"


    ######################################
    # topo = "imp2D"
    # algo = "gossip"
    # start = 4
    # # lim = 16385
    # thresh = 0.75
    # lim = 34970 
    # test_values(topo, algo, start, lim, thresh)

  end 
  
end
#GossipSimulator.start