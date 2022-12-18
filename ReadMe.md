# Project Report – Gossip & PushSum Simulator

# What is working:
Both Gossip and Push Sum algorithms have been implemented for the 4 topologies ie. 2D, full, Imp3D and line.
Also, we implemented and documented the Bonus part which is an implementation of dropout ie. a percentage of random actors are temporarily disabled.
This is done to replicate and understand, real world senario's where nodes might go down. Read more about it in the Report attached in zip.

# What is the largest network you managed to deal with for each type of topology and algorithm?
Gossip:
- 2D: 10000 Nodes in 5068 sec
- full: 10000 Nodes in 682 sec
- Imp3D: 10000 Nodes in 796 sec
- line: 10000 Nodes in 9676 sec
Push-Sum:
- 2D: 2750 Nodes in 4110 sec
- full: 5000 Nodes in 1240 sec
- Imp3D: 1862 Nodes in 1862 sec
- line: 2000 Nodes in 2744 sec

# Exection Instructions:

Enter Erlang envoirment in terminal using command:

-> erl

File: Project2.erl

-> c(project2).

# Instructions for Gossip: 

Here replace 10 with any number of nodes.

-> project2:run(10, "2D", "gossip"). 

-> project2:run(10, "full", "gossip"). 

-> project2:run(10, "Imp3D", "gossip").

-> project2:run(10, "line", "gossip").  

# Instructions for Push-Sum:

-> project2:run(10, "2D", "push-sum"). 

-> project2:run(10, "full", "push-sum"). 

-> project2:run(10, "Imp3D", "push-sum"). 

-> project2:run(10, "line", "push-sum").

File: Project2.erl
# Instructions for Gossip with 20% Dropout:

-> project2bonus:run(10, "2D", "gossip", 20).

-> project2bonus:run(10, "full", "gossip", 20). 

-> project2bonus:run(10, "Imp3D", "gossip", 20). 

-> project2bonus:run(10, "line", "gossip", 20).

# Instructions for Gossip with 50% Dropout:

-> project2bonus:run(10, "2D", "gossip", 50). 

-> project2bonus:run(10, "full", "gossip", 50).

-> project2bonus:run(10, "Imp3D", "gossip", 50). 

-> project2bonus:run(10, "line", "gossip", 50). 

# Instructions for Gossip with 80% Dropout:

-> project2bonus:run(10, "2D", "gossip", 80).

-> project2bonus:run(10, "full", "gossip", 80).

-> project2bonus:run(10, "Imp3D", "gossip", 80).

-> project2bonus:run(10, "line", "gossip", 80).
