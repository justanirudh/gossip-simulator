# GossipSimulator

#Contents: project2 directory that has the:
1. source code: Entire source code of this project
2. Graphs.xlsx: Contains 3 graphs along with their respective data:
* Graph-1: Four topologies for Gossip algo where convergence means all nodes have heard the rumor at least once
* Graph-2: Four topologies for Gossip algo where convergence means at least 50% of nodes have heard the rumor at least 10 times (This convergence condition is used in the final code submission)
* Graph-3: Four topologies for PushSum algo where convergence means 75% of nodes have converged to a value for Full, 2D and imp2D and 50% of nodes have converged to a value for line. 

##Some design decisions
1. Every node, after receipt of a rumor or (sum, weight), continuously transmits the rumor or (sum/2, weight/2) every 100 milliseconds
2. All Times are in microseconds
3. If the provided value of num is not a perfect square for 2D and imp2D topologies, the nearest perfect sqaure is used as the value of num

* Team members (1): Anirudh Pathak
* What is working: All combinations of topologies and algorithms except [PushSum + 2D] which does converge but extremely slowly. Further explaination for each topo + algo is in the 'Some interesting findings' section.
* What is the largest network you managed to deal with for each type of topology and algorithm:
..* Gossip + Full = 16,384
..* Gossip + Line = 4,096
..* Gossip + 2D = 34,969
..* Gossip + imp2D = 34,969
..* PushSum + Full = 8,192
..* PushSum + Line = 8,192
..* PushSum + 2D = Converges extremely slowly
..* PushSum + imp2D = 17,424

## Gossip
**Convergence: 50% of nodes have heard the rumor at least 10 times**
*I have attached two graphs with different interpretation of convergence*
###Graph(s) attached: _Graph-1_, _Graph-2_
Graph-1: Convergence means all nodes have heard the rumor at least once
Graph-2: Convergence means at least 50% of nodes have heard the rumor at least 10 times (This convergence condition is used in the final code submission)

### Some interesting findings in Gossip
1. For gossip + line, if adjacent neighbours (1 or 2) are inactive for an active node, the node will always remain active as it will never hear more rumors
2. For gossip + 2D, if adjacent neighbours (2 or 3 or 4) are inactive for an active node, the node will always remain active as it will never hear more rumors
3. For Gossip algo where convergence is defined as all nodes hearing the rumor at least once, Full does better than 2D and Imperfect 2D for smaller values of number of nodes but as number of nodes increases Imperfect 2D does better than 2D which does better than Full which does better than Line (Graph-1)
4. For Gossip algo where convergence is defined as at least 50% of nodes hearing the rumor 10 times, Full does better than 2D and Imperfect 2D for smaller values of number of nodes but as number of nodes increases Imperfect 2D does better than 2D which does better than Full which does better than Line (Graph-1). This observation is similar to that of point 4. 
5. For gossip + line, there might be **rare** cases when a set of nodes dont hear the rumor even once. This might happen if a node becomes inactive before activating its next neighbour

##Push-sum
**Convergence: For Full, 2D and imp2D, 75% of nodes have converged to a value. For line, 50% of nodes have converged to a value**
###Graph(s) attached: _Graph-3_
For _full_ and _imp2D_, convergence occurs for 75% of nodes. For _line_, convergence occurs if we lower the threshold to 50%. For _2D_, convergence occurs extremely slowly

### Some interesting findings in PushSum
1. For push-sum + imp2D, at least 75% of the nodes converge to a **correct** value of global average(Graph-3)
2. For push-sum + full, at least 75% of the nodes converge to a **correct** value of global average (Graph-3)
3. For larger values of number of nodes, Imperfect 2D does better than Full.
4. For push-sum + line, at least 50% of nodes converge but do not converge to the same value (of global average) (Graph-3)
5. For push-sum + 2D, nodes converge to a **correct** value of global average but extremely slowly
6. For push-sum + 2D and push-sum + line, there might be **rare** cases when some nodes dont receive the sum even once




