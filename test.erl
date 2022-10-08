-module('test').
-author("Ammar").

%% API
-export([run/1, actorReceive/1, actorSender/1]). 
 
actorSender(PID) ->
    PID ! {s2r, "rumor"}.

actorReceive(0) ->
    "all rumors are received";
actorReceive(NumNodes) -> 
    receive
        {s2r, Msg} ->
            io:fwrite("~p~n",[Msg]),
            actorReceive(NumNodes - 1)
    end.
 
 run(NumNodes) ->
    PID = spawn(test, actorReceive, [NumNodes]),
    [spawn(test, actorSender, [PID]) || X <- lists:seq(1, NumNodes)].