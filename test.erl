-module('test').
-author("Ammar").

%% API
-export([run/1, actorReceive/1, actorSender/1]). 
 
actorSender(PID) ->
    PID ! {s2r, "rumor"},
    io:fwrite("~p Sender ~n", [self()]).

actorReceive(0) ->
    io:fwrite("~p Terminating Receiver ~n", [self()]),
    "all rumors are received";
actorReceive(NumNodes) -> 
    receive
        {s2r, Msg} ->
            io:fwrite("~p~n", [Msg]),
            actorReceive(NumNodes - 1)
    end.
 


run(NumNodes) ->
    PID = spawn(test, actorReceive, [NumNodes]),
    % % Line
    % List = [spawn(test, actorSender, [PID]) || _ <- lists:seq(1, NumNodes)],
    % List print
    % io:fwrite("~w~n", [List]),
    % List indexing
    % io:fwrite("~p here ~n ", [lists:nth(1, List)]),

    % 2D grid
    ListofList = [[spawn(test, actorSender, [PID]) || _ <- lists:seq(1, NumNodes)] || _ <- lists:seq(1, NumNodes)],
    % ListofList print
    io:fwrite("~w~n", [ListofList]),
    % ListofList indexing
    io:fwrite("~p here ~n ", [lists:nth(3, lists:nth(3, ListofList))]),
    
    done.