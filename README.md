# GossipSimulator

#TODO
1. Change all times to milliseconds?
2. Bonus part of question

##Some design decisions
1. Every node, after receipt of a rumor/(sum, weight), continuously transmits the rumor/(sum/2, weight/2) every 100 milliseconds
2. IMPORTANT: Times in the attached graphs are monotonic times in :native time units. It is returned when you use the monotonic_time/0 function (without any parameters). Time returned when you run the program is in milliseconds. This is returned when we use monotonic_time/1 with :millisecond as parameter

* Team members (1): Anirudh Pathak
* What is working: All combinations of topologies and algorithms + BONUS (TODO)
* What is the largest network you managed to deal with for each type of topology and algorithm:
..* Gossip + Full = 16,384
..* Gossip + Line = 4,096
..* Gossip + 2D = 34,969
..* Gossip + imp2D = 34,969
..* PushSum + Full = 8,192
..* PushSum + Line = 16,384
..* PushSum + 2D = 34,969
..* PushSum + imp2D = 8,649

## Gossip
**Convergence: 50% of nodes have heard the rumor at least 10 times**
*I have attached two graphs with different interpretation of convergence*
Graph1: Convergence means all nodes have heard the rumor at least once
Graph2: Convergence means 50% of nodes have heard the rumor at least 10 times (This condition is also used in code for convergence)

## Some interesting findings in Gossip
1. For gossip + line, there might be cases when a set of nodes dont hear the rumor even once. This might happen if a node becomes inactive before activating its next neighbour
2. For gossip + line, if adjacent neighbours (2) are inactive for an active node, the node will always remain active as it will never hear more rumors
3. For gossip + 2D, if adjacent neighbours (4) are inactive for an active node, the node will always remain active as it will never hear more rumors
4. In general, for Gossip algo where convergence is defined as all nodes hearing the rumor at least once, Full does better than Imperfect 2D which does better than 2D which does better than Line  
5. Interestingly, for Gossip algo where convergence is defined as all nodes hearing the rumor at least once, at larger values of number of nodes, imperfect 2D does better than full topology
6. For Gossip algo where convergence is defined as 50% of nodes hearing the rumor 10 times, at larger values of number of nodes, imperfect 2D does better than full which does better than 2D which does better than line

##Push-sum
**Convergence: 75% of nodes have converged to a value**
_Graph3_: For _full_ and _imp2D_, convergence occurs. For _line_, convergence occurs if we lower the threshold to 50%. For _2D_, convergence does not seem to occur

## Some interesting findings in Gossip
1. For push-sum + 2D and push-sum + line, some nodes dont receive the sum even once
2. For push-sum + line, nodes converge but do not converge to the same value (of global average)
3. For push-sum + full, almost all the nodes converge to a correct value of global average
4. For push-sum + 2D, nodes do converge to a global average but extremely slowly
5. For push-sum + imp2D, almost all nodes converge to a correct value of global average

