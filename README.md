# GossipSimulator

* Team members (1): Anirudh Pathak
* What is working: All combinations of topologies and algorithms + BONUS (TODO)
* What is the largest network you managed to deal with for each type of topology and algorithm:
..* Gossip + Full = 16,384
..* Gossip + Line = 4,096
..* Gossip + 2D = 34,969
..* Gossip + imp2D = 34,969
..* PushSum + Full
..* PushSum + Line
..* PushSum + 2D
..* PushSum + imp2D

## Some interesting findings

1. For push-sum + 2D and push-sum + line, some nodes dont receive the sum even once
2. For push-sum + line, All nodes do not converge to the same value
3. For gossip + line, there might be cases when a set of nodes dont heart he rumor even once. This might happen if a node becomes inactive before activating its next neighbour
4. For gossip + line, if adjacent neighbours (2) are inactive for an active node, the node will always remain active as it will never hear more rumors
5. For gossip + 2D, if adjacent neighbours (4) are inactive for an active node, the node will always remain active as it will never hear more rumors
6. In general, for Gossip algo where convergence is defined as all nodes hearing the rumor at least once, Full does better than Imperfect 2D which does better than 2D which does better than Line  
7. Interestingly, for Gossip algo where convergence is defined as all nodes hearing the rumor at least once, at larger values of number of nodes, imperfect 2D does better than full topology

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `project2` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:project2, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/project2](https://hexdocs.pm/project2).

