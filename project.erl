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
-export([run/3]).


run(NumNodes, Algorithm, Topology) ->
    io:format("~p",[self()]).
%     case Algorithm of
%     "gossip" ->
%       case Topology of
%         "full" -> done;
%         "2D" -> done;
%         "line" -> done;
%         "Imp2D" -> done
%       end;

%     "push-sum" ->
%       case Topology of
%         "full" -> done;
%         "2D" -> done;
%         "line" -> done;
%         "Imp2D" -> done
%       end

%   end.