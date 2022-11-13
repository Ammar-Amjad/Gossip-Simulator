-module('test').
-author("Ammar").

%% API
-export([run/1, supervisor/1, actor/0]). 
 
% actorSender(PID) ->
%     PID ! {s2r, "rumor"},
%     io:fwrite("~p Sender ~n", [self()]).

% actorReceive(0) ->
%     io:fwrite("~p Terminating Receiver ~n", [self()]),
%     "all rumors are received";
% actorReceive(NumNodes) -> 
%     receive
%         {s2r, Msg} ->
%             io:fwrite("~p~n", [Msg]),
%             actorReceive(NumNodes - 1)
%     end.
 
actor() -> 
    receive
        {lob, ListofNeighbors} ->
            done
    end.

sendNeighborsToActors(ListofList, NumNodes, curridx) when curridx =< NumNodes ->
    
     

    case NumNodes of
            "full" -> done;
            "2D" -> gossip2D;
            "line" -> done;
            "Imp2D" -> done
        end
    lists:nth(col, lists:nth(row, ListofList)),

    lists:nth(1, lists:nth(1, ListofList)) ! NeighborList,
    sendNeighborsToActors(ListofList, NumNodes, curridx + 1)
    .

supervisor(ListofList) -> 
    sendNeighborsToActors(ListofList, NumNodes, 1).

run(NumNodes) ->
    PID = spawn(test, supervisor, [NumNodes]),
    % % Line
    % List = [spawn(test, actorSender, [PID]) || _ <- lists:seq(1, NumNodes)],
    % List print
    % io:fwrite("~w~n", [List]),
    % List indexing
    % io:fwrite("~p here ~n ", [lists:nth(1, List)]),

    % 2D grid
    ListofList = [[spawn(test, actor, [PID]) || _ <- lists:seq(1, NumNodes)] || _ <- lists:seq(1, NumNodes)],
    % ListofList print
    io:fwrite("~w~n", [ListofList]),
    % ListofList indexing
    io:fwrite("~p here ~n ", [lists:nth(3, lists:nth(3, ListofList))]),
    
    done.