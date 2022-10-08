%%%-------------------------------------------------------------------
%%% @author Ammar
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Sep 2022 4:27 PM
%%%-------------------------------------------------------------------
-module('project').
-author("Ammar").

%% API
-export([run/1, supervisor/1]).

supervisor(0) ->
    io:fwrite("~p Terminating Receiver ~n", [self()]),
    "all rumors are received";
supervisor(NumNodes) -> 
    receive
        {a2s, Msg} ->
            io:fwrite("~p~n", [Msg]),
            supervisor(NumNodes - 1)
    end.

gossip2D(NumNodes) -> 
    .

run(NumNodes) ->
    Algorithm = "gossip",
    Topology = "2D",

    case Algorithm of
    "gossip" ->
        case Topology of
            "full" -> done;
            "2D" -> gossip2D;
            "line" -> done;
            "Imp2D" -> done
        end
    end.