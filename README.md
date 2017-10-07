# GossipSimulator

#TODO
* Fix time and change it in all graphs
* Bonus part of question?
* Remove gossip conv. definition-1?

##Some design decisions
1. Every node, after receipt of a rumor or (sum, weight), continuously transmits the rumor or (sum/2, weight/2) every 100 milliseconds
2. **IMPORTANT:** Times in the attached graphs are monotonic times in :native time units. It is returned when we use the monotonic_time/0 function (without any parameters). I decided on using them because they give good resolution for graphs. On the other hand, time returned when we run the program is in milliseconds. This is returned when we use monotonic_time/1 with :millisecond as parameter
3. If the provided value of num is not a perfect square for 2D and imp2D topologies, the nearest perfect sqaure is used as the value of num

* Team members (1): Anirudh Pathak
* What is working: All combinations of topologies and algorithms in terms of their respective definitions of convergence (which is included below for each algo). Further explaination for each topo + algo is in the 'Some interesting findings' section. Also, did the BONUS (TODO) part
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
###Graph(s) attached: _Graph-1_, _Graph-2_
Graph-1: Convergence means all nodes have heard the rumor at least once
Graph-2: Convergence means at least 50% of nodes have heard the rumor at least 10 times (This convergence condition is used in the final code submission)

### Some interesting findings in Gossip
1. For gossip + line, there might be cases when a set of nodes dont hear the rumor even once. This might happen if a node becomes inactive before activating its next neighbour
2. For gossip + line, if adjacent neighbours (1 or 2) are inactive for an active node, the node will always remain active as it will never hear more rumors
3. For gossip + 2D, if adjacent neighbours (2 or 3 or 4) are inactive for an active node, the node will always remain active as it will never hear more rumors
4. In general, for Gossip algo where convergence is defined as all nodes hearing the rumor at least once, Full does better than Imperfect 2D which does better than 2D which does better than Line (Graph-1)
5. Interestingly, for Gossip algo where convergence is defined as all nodes hearing the rumor at least once, at larger values of number of nodes, imperfect 2D does better than full topology (Graph-1)
6. For Gossip algo where convergence is defined as at least 50% of nodes hearing the rumor 10 times, at larger values of number of nodes, imperfect 2D does better than full which does better than 2D which does better than line (Graph-2)

##Push-sum
**Convergence: For Full, 2D and imp2D, 75% of nodes have converged to a value. For line, 50% of nodes have converged to a value**
###Graph(s) attached: _Graph-3_
For _full_ and _imp2D_, convergence occurs for 75% of nodes. For _line_, convergence occurs if we lower the threshold to 50%. For _2D_, convergence occurs extremely slowly

### Some interesting findings in PushSum
1. For push-sum + imp2D, at least 75% of the nodes converge to a **correct** value of global average(Graph-3)
2. For push-sum + full, at least 75% of the nodes converge to a **correct** value of global average (Graph-3)
3. For push-sum + line, at least 50% of nodes converge but do not converge to the same value (of global average) (Graph-3)
4. For push-sum + 2D, nodes converge to a **correct** value of global average but extremely slowly
5. For push-sum + 2D and push-sum + line, sometimes some nodes dont receive the sum even once



