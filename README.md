# GossipSimulator

#Contents: project2 directory that contains:
1. source code: Entire source code of this project
2. Graphs.xlsx: Contains 5 graphs along with their respective data:
* Graph-1-1: All four topologies for Gossip algo where convergence means all nodes have heard the rumor at least once
* Graph-1-2: All four topologies for Gossip algo where convergence means at least 50% of nodes have heard the rumor at least 10 times (This convergence condition is used in the final code submission)
* Graph-2-1: [Push-Sum + Full] and [Push-Sum + imp2D] where convergence means 75% of nodes have converged to the Global Average
* Graph-2-2: [Push-Sum + 2D] where convergence means at least 1 node converged to the Global Average
* Graph-2-3: [Push-Sum + Line] where convergence means 50% of nodes converged to a value not necessarily global average

##Some design decisions
1. Every node, after receipt of a rumor or (sum, weight), continuously transmits the rumor or (sum/2, weight/2) every 100 milliseconds
2. All Times are in microseconds
3. If the provided value of num is not a perfect square for 2D and imp2D topologies, the nearest perfect sqaure is used as the value of num

* Team members (1): Anirudh Pathak
* What is working: All combinations of topologies and algorithms in accordance with their definitions of convergence. Further explaination for each topo + algo is in the 'Some interesting findings' section.
* What is the largest network you managed to deal with for each type of topology and algorithm:
..* Gossip + Full = 16,384
..* Gossip + Line = 2,048
..* Gossip + 2D = 34,969
..* Gossip + imp2D = 34,969
..* PushSum + Full = 8,192
..* PushSum + Line = 8,192
..* PushSum + 2D = 17,424
..* PushSum + imp2D = 17,424

## Gossip
**Convergence: 50% of nodes have heard the rumor at least 10 times**
*I have attached two graphs with different interpretation of convergence*
###Graph(s) attached: _Graph-1-1_, _Graph-1-2_
* Graph-1-1: All topologies; Convergence means all nodes have heard the rumor at least once
* Graph-1-2: All topologoes; Convergence means at least 50% of nodes have heard the rumor at least 10 times (This convergence condition is used in the final code submission)

### Some interesting findings in Gossip
1. For gossip + line, if adjacent neighbours (1 or 2) are inactive for an active node, the node will always remain active as it will never hear more rumors
2. For gossip + 2D, if adjacent neighbours (2 or 3 or 4) are inactive for an active node, the node will always remain active as it will never hear more rumors
3. For Gossip algo where convergence is defined as all nodes hearing the rumor at least once, Full does better than 2D and Imperfect 2D for smaller values of number of nodes but as number of nodes increases Imperfect 2D does better than 2D which does better than Full which does better than Line (Graph-1-1)
4. For Gossip algo where convergence is defined as at least 50% of nodes hearing the rumor 10 times, Full does better than 2D and Imperfect 2D for smaller values of number of nodes but as number of nodes increases Imperfect 2D does better than 2D which does better than Full which does better than Line (Graph-1-2). This observation is similar to that of point 4. 
5. For gossip + line, there might be **rare** cases when a set of nodes dont hear the rumor even once. This might happen if a node becomes inactive before activating its next neighbour

##Push-sum
**Convergence: For Full and imp2D, 75% of nodes have converged to the global average. For 2D, at least one node has converged to the global average. For line, 50% of nodes have converged to some value, not necessarily the global average**
###Graph(s) attached: _Graph-2-1_,_Graph-2-3_,_Graph-2-3_ 
* Graph-2-1: Full and imp2D; Convergence means at least 75% nodes converged to the global average
* Graph-2-2: 2D; Convergecne means at least 1 node converged to the global average
* Graph-2-3: Line; Convergence means 50% nodes converged to a value, not necessarily the global average

### Some interesting findings in PushSum
1. For push-sum + imp2D, at least 75% of the nodes converge to a **correct** value of global average(Graph-2-1)
2. For push-sum + full, at least 75% of the nodes converge to a **correct** value of global average (Graph-2-1)
3. For larger values of number of nodes, Imperfect 2D does better than Full.(Graph-2-1)
4. For push-sum + 2D, nodes converge to a **correct** value of global average but extremely slowly. Since it is so slow, the convergence condition used to create the graph is that at least 1 node converged to the global average rather than 75% converging. (Graph-2-2)
5. For push-sum + line, at least 50% of nodes converge **but do not converge to the same value** (of global average) (Graph-2-3)
6. For push-sum + 2D and push-sum + line, there might be **rare** cases when some nodes dont receive the sum even once




