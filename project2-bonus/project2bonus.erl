-module('project2bonus').
-author("Ammar").

%% API
-export([run/4, actorGossip/3, printList/1, printelement/3, gossip2D/2, gossipFull/2, getidx2D/4, sendRumor2DGossip/5,
  sendRumorFullGossip/3, sendNeighbors2D/4, sendNeighborsFull/4, supervisorPushSum/1, supervisorGossip/1, checkConvergence/2, sendRumor2DPushSum/6,
  actorPushSum/2]).

checkConvergence(S, W) -> round((S / W) * 10000000000).

sendRumor2DGossip(Rumor, Left, Right, Up, Down) ->
  Turn = rand:uniform(4),
  if
    (Left > -1) and (Turn == 1) -> Left ! {rumor, Rumor, false};
    (Right > -1) and (Turn == 2) -> Right ! {rumor, Rumor, false};
    (Up > -1) and (Turn == 3) -> Up ! {rumor, Rumor, false};
    (Down > -1) and (Turn == 4) -> Down ! {rumor, Rumor, false};
    true -> 
  done
  end,
  sendRumor2DGossip(Rumor, Left, Right, Up, Down).

sendRumorFullGossip(Rumor, ListofList, Rowcount) ->
  I = rand:uniform(Rowcount),
  J = rand:uniform(Rowcount),
  lists:nth(J, lists:nth(I, ListofList)) ! {rumor, Rumor, false},
  sendRumorFullGossip(Rumor, ListofList, Rowcount).

sendRumorI2DGossip(Rumor, Left, Right, Up, Down, ListofList, Rowcount) ->
  I = rand:uniform(Rowcount),
  J = rand:uniform(Rowcount),
  RandomPID = lists:nth(J, lists:nth(I, ListofList)),
  Turn = rand:uniform(5),
  if
    (Left > -1) and (Turn == 1) -> Left ! {rumor, Rumor, false};
    (Right > -1) and (Turn == 2) -> Right ! {rumor, Rumor, false};
    (Up > -1) and (Turn == 3) -> Up ! {rumor, Rumor, false};
    (Down > -1) and (Turn == 4) -> Down ! {rumor, Rumor, false};
    (Turn == 5) -> RandomPID ! {rumor, Rumor, false};
    true -> done
  end,
  sendRumorI2DGossip(Rumor, Left, Right, Up, Down, ListofList, Rowcount)
  .
sendRumorLineGossip(Rumor, Left, Right) ->
  Turn = rand:uniform(2),
  if
    (Left > -1) and (Turn == 1) -> Left ! {rumor, Rumor, false};
    (Right > -1) and (Turn == 2) -> Right ! {rumor, Rumor, false};
    true -> done
  end,
  sendRumorLineGossip(Rumor, Left, Right)
  .

actorGossip(SuperPID, Rowcount, DropPercent) ->
    receive
      {rumor, Rumor, FreePass} ->
          P = rand:uniform(100),
          if ( P >= DropPercent) or ( FreePass )  -> 
            % io:fwrite("~nTurn off node~n"),
              receive
              {neighbors2D, Left, Right, Up, Down} ->
                  SuperPID ! {gotit, "I heard a rumor!"},
                  sendRumor2DGossip(Rumor, Left, Right, Up, Down);
              {neighborsFull, ListofList} ->
                  SuperPID ! {gotit, "I heard a rumor!"},
                  sendRumorFullGossip(Rumor, ListofList, Rowcount);
              {neighborsI2D, Left, Right, Up, Down, ListofList} ->
                  SuperPID ! {gotit, "I heard a rumor!"},
                  sendRumorI2DGossip(Rumor, Left, Right, Up, Down, ListofList, Rowcount);
              {neighborsLine, Left, Right} ->
                  SuperPID ! {gotit, "I heard a rumor!"},
                  sendRumorLineGossip(Rumor, Left, Right)
              end;
            true -> 
              timer:sleep(300), % 300ms delay
              actorGossip(SuperPID, Rowcount, DropPercent)
        end
    end
  .

sendRumor2DPushSum(Left, Right, Up, Down, NewS, NewW) ->
  Turn = rand:uniform(4),
  if
    (Turn == 1) -> 
      if (Left > -1) -> Left ! {sw, NewS, NewW}; 
      true -> sendRumor2DPushSum(Left, Right, Up, Down, NewS, NewW) end;
    (Turn == 2) -> 
      if (Right > -1) -> Right ! {sw, NewS, NewW}; 
      true -> sendRumor2DPushSum(Left, Right, Up, Down, NewS, NewW) end;
    (Turn == 3) -> 
      if (Up > -1) -> Up ! {sw, NewS, NewW}; 
      true -> sendRumor2DPushSum(Left, Right, Up, Down, NewS, NewW) end;
    (Turn == 4) -> 
      if (Down > -1) -> Down ! {sw, NewS, NewW}; 
      true -> sendRumor2DPushSum(Left, Right, Up, Down, NewS, NewW) end;
    true -> done
  end
  .

sendRumorFullPushSum(ListofList, Rowcount, NewS, NewW) ->
  I = rand:uniform(Rowcount),
  J = rand:uniform(Rowcount),
  lists:nth(J, lists:nth(I, ListofList)) ! {sw, NewS, NewW}.

sendRumorI2DPushSum(Left, Right, Up, Down, ListofList, Rowcount, NewS, NewW) ->
  I = rand:uniform(Rowcount),
  J = rand:uniform(Rowcount),
  RandomPID = lists:nth(J, lists:nth(I, ListofList)),
  Turn = rand:uniform(5),
  if
    (Turn == 1) -> 
      if (Left > -1) -> Left ! {sw, NewS, NewW}; 
      true -> sendRumorI2DPushSum(Left, Right, Up, Down, ListofList, Rowcount, NewS, NewW) end;
    (Turn == 2) -> 
      if (Right > -1) -> Right ! {sw, NewS, NewW}; 
      true ->sendRumorI2DPushSum(Left, Right, Up, Down, ListofList, Rowcount, NewS, NewW) end;
    (Turn == 3) -> 
      if (Up > -1) -> Up ! {sw, NewS, NewW}; 
      true -> sendRumorI2DPushSum(Left, Right, Up, Down, ListofList, Rowcount, NewS, NewW) end;
    (Turn == 4) -> 
      if (Down > -1) -> Down ! {sw, NewS, NewW}; 
      true -> sendRumorI2DPushSum(Left, Right, Up, Down, ListofList, Rowcount, NewS, NewW) end;
    (Turn == 5) ->  RandomPID ! {sw, NewS, NewW}; 
    true -> done
  end
  .
sendRumorLinePushSum(Left, Right, NewS, NewW) ->
  Turn = rand:uniform(2),
  if
    (Turn == 1) -> 
      if (Left > -1) -> Left ! {sw, NewS, NewW}; 
      true -> sendRumorLinePushSum(Left, Right, NewS, NewW) end;
    (Turn == 2) -> 
      if (Right > -1) -> Right ! {sw, NewS, NewW}; 
      true -> sendRumorLinePushSum(Left, Right, NewS, NewW) end;
    true -> done
  end
  .

actorPushSum2D(SuperPID, Rowcount, Left, Right, Up, Down, S, W, 0) ->
  SuperPID ! {converged, S, W ,"I have got same ratio 3 times"},
  actorPushSum2D(SuperPID, Rowcount, Left, Right, Up, Down, S, W, -1);
actorPushSum2D(SuperPID, Rowcount, Left, Right, Up, Down, S, W, Count) -> 
  receive {sw, Sn, Wn} ->
    
    NewS = (Sn+S)/2, 
    NewW = (Wn+W)/2,
    sendRumor2DPushSum(Left, Right, Up, Down, NewS, NewW),
    Bool1 = checkConvergence(S, W),
    Bool2 = checkConvergence(NewS, NewW),
    % io:fwrite("~n~p ~p ~p ~p ~p ~p ~n", [self(), S, W, Bool1, Bool2, (Bool1 /= Bool2)]),
    if Bool1 /= Bool2 ->
      actorPushSum2D(SuperPID, Rowcount, Left, Right, Up, Down, NewS, NewW, 3); 
    true ->
      actorPushSum2D(SuperPID, Rowcount, Left, Right, Up, Down, NewS, NewW, Count-1)
    end
  end.
actorPushSumFull(SuperPID, Rowcount, ListofList, S, W, 0) ->
  SuperPID ! {converged, S, W ,"I have got same ratio 3 times"},
  actorPushSumFull(SuperPID, Rowcount, ListofList, S, W, -1);
actorPushSumFull(SuperPID, Rowcount, ListofList, S, W, Count) -> 
  receive {sw, Sn, Wn} ->
    
    NewS = (Sn+S)/2, 
    NewW = (Wn+W)/2,
    sendRumorFullPushSum(ListofList, Rowcount, NewS, NewW),
    Bool1 = checkConvergence(S, W),
    Bool2 = checkConvergence(NewS, NewW),
    % io:fwrite("~n~p ~p ~p ~p ~p ~p ~n", [self(), S, W, Bool1, Bool2, (Bool1 /= Bool2)]),
    if Bool1 /= Bool2 ->
      actorPushSumFull(SuperPID, Rowcount, ListofList, NewS, NewW, 3); 
    true ->
      actorPushSumFull(SuperPID, Rowcount, ListofList, NewS, NewW, Count-1)
    end
  end.
actorPushSumI2D(SuperPID, Rowcount, Left, Right, Up, Down, ListofList, S, W, 0) ->
  SuperPID ! {converged, S, W ,"I have got same ratio 3 times"},
  actorPushSumI2D(SuperPID, Rowcount, Left, Right, Up, Down, ListofList, S, W, -1);
actorPushSumI2D(SuperPID, Rowcount, Left, Right, Up, Down, ListofList, S, W, Count) -> 
  receive {sw, Sn, Wn} ->
    NewS = (Sn+S)/2, 
    NewW = (Wn+W)/2,
    sendRumorI2DPushSum(Left, Right, Up, Down, ListofList, Rowcount, NewS, NewW),
    Bool1 = checkConvergence(S, W),
    Bool2 = checkConvergence(NewS, NewW),
    % io:fwrite("~n~p ~p ~p ~p ~p ~p ~n", [self(), S, W, Bool1, Bool2, (Bool1 /= Bool2)]),
    if Bool1 /= Bool2 ->
      actorPushSumI2D(SuperPID, Rowcount, Left, Right, Up, Down, ListofList, NewS, NewW, 3); 
    true ->
      actorPushSumI2D(SuperPID, Rowcount, Left, Right, Up, Down, ListofList, NewS, NewW, Count-1)
    end
  end.
actorPushSumLine(SuperPID, Rowcount, Left, Right, S, W, 0) ->
  SuperPID ! {converged, S, W ,"I have got same ratio 3 times"},
  actorPushSumLine(SuperPID, Rowcount, Left, Right, S, W, -1);
actorPushSumLine(SuperPID, Rowcount, Left, Right, S, W, Count) -> 
  receive {sw, Sn, Wn} ->
    NewS = (Sn+S)/2, 
    NewW = (Wn+W)/2,
    sendRumorLinePushSum(Left, Right, NewS, NewW),
    Bool1 = checkConvergence(S, W),
    Bool2 = checkConvergence(NewS, NewW),
    % io:fwrite("~n~p ~p ~p ~p ~p ~p ~n", [self(), S, W, Bool1, Bool2, (Bool1 /= Bool2)]),
    if Bool1 /= Bool2 ->
      actorPushSumLine(SuperPID, Rowcount, Left, Right, NewS, NewW, 3); 
    true ->
      actorPushSumLine(SuperPID, Rowcount, Left, Right, NewS, NewW, Count-1)
    end
  end.
actorPushSum(SuperPID, Rowcount) ->
  
  receive
    {neighbors2D, Left, Right, Up, Down, S, W} ->
      actorPushSum2D(SuperPID, Rowcount, Left, Right, Up, Down, S, W, 3);
    {neighborsFull, ListofList, S, W} ->
      actorPushSumFull(SuperPID, Rowcount, ListofList, S, W, 3);
    {neighborsI2D, Left, Right, Up, Down, ListofList, S, W} ->
      actorPushSumI2D(SuperPID, Rowcount, Left, Right, Up, Down, ListofList, S, W, 3);
    {neighborsLine, Left, Right, S, W} ->
      actorPushSumLine(SuperPID, Rowcount, Left, Right, S, W, 3)
    end
  .

sendNeighbors2D(I, J, ListofList, SqrtNumNodes) ->
  RPID = lists:nth(J, lists:nth(I, ListofList)),
  if (J > 1) -> Left = lists:nth(J-1, lists:nth(I, ListofList)); true -> Left = -1 end,
  if (J < SqrtNumNodes) -> Right = lists:nth(J+1, lists:nth(I, ListofList)); true -> Right = -1 end,
  if (I > 1 ) -> Up =  lists:nth(J, lists:nth(I-1, ListofList)); true -> Up = -1 end,
  if (I < SqrtNumNodes) -> Down = lists:nth(J, lists:nth(I+1, ListofList)); true -> Down = -1 end,

  RPID ! {neighbors2D, Left, Right, Up, Down}
  .

sendNeighborsFull(I, J, ListofList, _) ->
  RPID = lists:nth(J, lists:nth(I, ListofList)),
  RPID ! {neighborsFull, ListofList}
  .
sendNeighborsI2D(I, J, ListofList, SqrtNumNodes) ->
  RPID = lists:nth(J, lists:nth(I, ListofList)),
  if (J > 1) -> Left = lists:nth(J-1, lists:nth(I, ListofList)); true -> Left = -1 end,
  if (J < SqrtNumNodes) -> Right = lists:nth(J+1, lists:nth(I, ListofList)); true -> Right = -1 end,
  if (I > 1 ) -> Up =  lists:nth(J, lists:nth(I-1, ListofList)); true -> Up = -1 end,
  if (I < SqrtNumNodes) -> Down = lists:nth(J, lists:nth(I+1, ListofList)); true -> Down = -1 end,

  RPID ! {neighborsI2D, Left, Right, Up, Down, ListofList}
  .
sendNeighborsLine(I, ListofList, SqrtNumNodes) ->
  RPID = lists:nth(I, ListofList),
  if (I > 1) -> Left = lists:nth(I-1, ListofList); true -> Left = -1 end,
  if (I < SqrtNumNodes) -> Right = lists:nth(I+1, ListofList); true -> Right = -1 end,
  RPID ! {neighborsLine, Left, Right}
  .

sendNeighbors2DPushSum(I, J, ListofList, SqrtNumNodes) ->
  RPID = lists:nth(J, lists:nth(I, ListofList)),
  if (J > 1) -> Left = lists:nth(J-1, lists:nth(I, ListofList)); true -> Left = -1 end,
  if (J < SqrtNumNodes) -> Right = lists:nth(J+1, lists:nth(I, ListofList)); true -> Right = -1 end,
  if (I > 1 ) -> Up =  lists:nth(J, lists:nth(I-1, ListofList)); true -> Up = -1 end,
  if (I < SqrtNumNodes) -> Down = lists:nth(J, lists:nth(I+1, ListofList)); true -> Down = -1 end,

  RPID ! {neighbors2D, Left, Right, Up, Down, ((I-1) * SqrtNumNodes + J), 1}
  .

sendNeighborsFullPushSum(I, J, ListofList, SqrtNumNodes) ->
  RPID = lists:nth(J, lists:nth(I, ListofList)),
  RPID ! {neighborsFull, ListofList, ((I-1) * SqrtNumNodes + J), 1}
  .
sendNeighborsI2DPushSum(I, J, ListofList, SqrtNumNodes) ->
  RPID = lists:nth(J, lists:nth(I, ListofList)),
  if (J > 1) -> Left = lists:nth(J-1, lists:nth(I, ListofList)); true -> Left = -1 end,
  if (J < SqrtNumNodes) -> Right = lists:nth(J+1, lists:nth(I, ListofList)); true -> Right = -1 end,
  if (I > 1 ) -> Up =  lists:nth(J, lists:nth(I-1, ListofList)); true -> Up = -1 end,
  if (I < SqrtNumNodes) -> Down = lists:nth(J, lists:nth(I+1, ListofList)); true -> Down = -1 end,

  RPID ! {neighborsI2D, Left, Right, Up, Down, ListofList, ((I-1) * SqrtNumNodes + J), 1}
  .
sendNeighborsLinePushSum(I, ListofList, SqrtNumNodes) ->
  RPID = lists:nth(I, ListofList),
  if (I > 1) -> Left = lists:nth(I-1, ListofList); true -> Left = -1 end,
  if (I < SqrtNumNodes) -> Right = lists:nth(I+1, ListofList); true -> Right = -1 end,
  RPID ! {neighborsLine, Left, Right, 1, 1}
  .

getidx2D(I, J, SqrtNumNodes, ListofList) ->
  % io:fwrite("~w", [SqrtNumNodes]),
  if
    I < SqrtNumNodes ->  sendNeighbors2D(I, J, ListofList, SqrtNumNodes), getidx2D(I+1, J, SqrtNumNodes, ListofList);
    J < SqrtNumNodes ->  sendNeighbors2D(I, J, ListofList, SqrtNumNodes), getidx2D(1, J+1, SqrtNumNodes, ListofList);
    (I == SqrtNumNodes) and (J == SqrtNumNodes) -> sendNeighbors2D(I, J, ListofList, SqrtNumNodes)
  end.
getidxFull(I, J, SqrtNumNodes, ListofList) ->
  % io:fwrite("~w", [SqrtNumNodes]),
  if
    I < SqrtNumNodes ->  sendNeighborsFull(I, J, ListofList, SqrtNumNodes), getidxFull(I+1, J, SqrtNumNodes, ListofList);
    J < SqrtNumNodes ->  sendNeighborsFull(I, J, ListofList, SqrtNumNodes), getidxFull(1, J+1, SqrtNumNodes, ListofList);
    (I == SqrtNumNodes) and (J == SqrtNumNodes) -> sendNeighborsFull(I, J, ListofList, SqrtNumNodes)
  end.
getidxI2D(I, J, SqrtNumNodes, ListofList) ->
  % io:fwrite("~w", [SqrtNumNodes]),
  if
    I < SqrtNumNodes ->  sendNeighborsI2D(I, J, ListofList, SqrtNumNodes), getidxI2D(I+1, J, SqrtNumNodes, ListofList);
    J < SqrtNumNodes ->  sendNeighborsI2D(I, J, ListofList, SqrtNumNodes), getidxI2D(1, J+1, SqrtNumNodes, ListofList);
    (I == SqrtNumNodes) and (J == SqrtNumNodes) -> sendNeighborsI2D(I, J, ListofList, SqrtNumNodes)
  end.
getidxLine(I, SqrtNumNodes, ListofList) ->
  % io:fwrite("~w", [SqrtNumNodes]),
  if
    I < SqrtNumNodes ->  sendNeighborsLine(I, ListofList, SqrtNumNodes), getidxLine(I+1, SqrtNumNodes, ListofList);
    (I == SqrtNumNodes) -> sendNeighborsLine(I, ListofList, SqrtNumNodes)
  end.

getidx2DPushSum(I, J, SqrtNumNodes, ListofList) ->
  % io:fwrite("~w", [SqrtNumNodes]),
  if
    I < SqrtNumNodes ->  sendNeighbors2DPushSum(I, J, ListofList, SqrtNumNodes), getidx2DPushSum(I+1, J, SqrtNumNodes, ListofList);
    J < SqrtNumNodes ->  sendNeighbors2DPushSum(I, J, ListofList, SqrtNumNodes), getidx2DPushSum(1, J+1, SqrtNumNodes, ListofList);
    (I == SqrtNumNodes) and (J == SqrtNumNodes) -> sendNeighbors2DPushSum(I, J, ListofList, SqrtNumNodes)
  end.
getidxFullPushSum(I, J, SqrtNumNodes, ListofList) ->
  % io:fwrite("~w", [SqrtNumNodes]),
  if
    I < SqrtNumNodes ->  sendNeighborsFullPushSum(I, J, ListofList, SqrtNumNodes), getidxFullPushSum(I+1, J, SqrtNumNodes, ListofList);
    J < SqrtNumNodes ->  sendNeighborsFullPushSum(I, J, ListofList, SqrtNumNodes), getidxFullPushSum(1, J+1, SqrtNumNodes, ListofList);
    (I == SqrtNumNodes) and (J == SqrtNumNodes) -> sendNeighborsFullPushSum(I, J, ListofList, SqrtNumNodes)
  end.
getidxI2DPushSum(I, J, SqrtNumNodes, ListofList) ->
  % io:fwrite("~w", [SqrtNumNodes]),
  if
    I < SqrtNumNodes ->  sendNeighborsI2DPushSum(I, J, ListofList, SqrtNumNodes), getidxI2DPushSum(I+1, J, SqrtNumNodes, ListofList);
    J < SqrtNumNodes ->  sendNeighborsI2DPushSum(I, J, ListofList, SqrtNumNodes), getidxI2DPushSum(1, J+1, SqrtNumNodes, ListofList);
    (I == SqrtNumNodes) and (J == SqrtNumNodes) -> sendNeighborsI2DPushSum(I, J, ListofList, SqrtNumNodes)
  end.
getidxLinePushSum(I, SqrtNumNodes, ListofList) ->
  % io:fwrite("~w", [SqrtNumNodes]),
  if
    I < SqrtNumNodes ->  sendNeighborsLinePushSum(I, ListofList, SqrtNumNodes), getidxLinePushSum(I+1, SqrtNumNodes, ListofList);
    (I == SqrtNumNodes) -> sendNeighborsLinePushSum(I, ListofList, SqrtNumNodes)
  end.


supervisorGossip(0) -> 
  {_, CPU_Time} = erlang:statistics(runtime),
  io:fwrite("~nAll nodes have received rumour!!!~n"),
  io:fwrite("Time Taken:~p s~n", [CPU_Time/10000]);
supervisorGossip(NumNodes) ->
  receive {gotit, _String} ->
    supervisorGossip(NumNodes - 1)
  end.

supervisorPushSum(0) -> 
  {_, CPU_Time} = erlang:statistics(runtime),
  io:fwrite("~nAll nodes have converged!!!~n"),
  io:fwrite("Time Taken:~p s~n", [CPU_Time/10000]);
supervisorPushSum(NumNodes) ->
  receive {converged, _S, _W, _} ->
    supervisorPushSum(NumNodes - 1)
  end.

printList(ListofList) ->
  io:fwrite("~w~n", [ListofList]).
printelement(I, J, ListofList) ->
  io:fwrite("~w~w", [I,J]),
  io:fwrite("~p here ~n ", [lists:nth(J, lists:nth(I, ListofList))]).

gossip2D(NumNodes, DropPercent) ->
  % 2D grid
  Rowcount =  round(math:sqrt(NumNodes)),
  ListofList = [[spawn(project2bonus, actorGossip, [self(), Rowcount, DropPercent]) || _ <- lists:seq(1, Rowcount)] || _ <- lists:seq(1, Rowcount)],
  % printList(ListofList),
  getidx2D(1, 1, round(math:sqrt(NumNodes)), ListofList),
  RPID = lists:nth(1, lists:nth(1, ListofList)),
  erlang:system_flag(scheduler_wall_time, true),
  RPID ! {rumor, "Rumor", true},
  supervisorGossip(Rowcount*Rowcount).
gossipFull(NumNodes, DropPercent) ->
  % 2D grid
  Rowcount =  round(math:sqrt(NumNodes)),
  ListofList = [[spawn(project2bonus, actorGossip, [self(), Rowcount, DropPercent]) || _ <- lists:seq(1, Rowcount)] || _ <- lists:seq(1, Rowcount)],
  % printList(ListofList),
  getidxFull(1, 1, round(math:sqrt(NumNodes)), ListofList),
  RPID = lists:nth(1, lists:nth(1, ListofList)),
  RPID ! {rumor, "Rumor", true},
  supervisorGossip(Rowcount*Rowcount).

gossipI2D(NumNodes, DropPercent) ->
  % 2D grid
  Rowcount =  round(math:sqrt(NumNodes)),
  ListofList = [[spawn(project2bonus, actorGossip, [self(), Rowcount, DropPercent]) || _ <- lists:seq(1, Rowcount)] || _ <- lists:seq(1, Rowcount)],
  % printList(ListofList),
  getidxI2D(1, 1, round(math:sqrt(NumNodes)), ListofList),
  RPID = lists:nth(1, lists:nth(1, ListofList)),
  RPID ! {rumor, "Rumor", true},
  supervisorGossip(Rowcount*Rowcount).

gossipLine(NumNodes, DropPercent) ->
  % 2D grid
  Rowcount =  round(math:sqrt(NumNodes)),
  List = [spawn(project2bonus, actorGossip, [self(), Rowcount, DropPercent]) || _ <- lists:seq(1, Rowcount*Rowcount)],
  % printList(List),
  getidxLine(1, Rowcount*Rowcount, List),
  RPID = lists:nth(1, List),
  RPID ! {rumor, "Rumor", true},
  supervisorGossip(Rowcount*Rowcount).

pushSum2D(NumNodes) ->
  Rowcount =  round(math:sqrt(NumNodes)),
  ListofList = [[spawn(project2bonus, actorPushSum, [self(), Rowcount]) || _ <- lists:seq(1, Rowcount)] || _ <- lists:seq(1, Rowcount)],
  % printList(ListofList),
  getidx2DPushSum(1, 1, round(math:sqrt(NumNodes)), ListofList),
  RPID = lists:nth(1, lists:nth(1, ListofList)),
  RPID ! {sw, 1, 1},
  supervisorPushSum(Rowcount*Rowcount)
  .
pushSumFull(NumNodes) ->
  Rowcount =  round(math:sqrt(NumNodes)),
  ListofList = [[spawn(project2bonus, actorPushSum, [self(), Rowcount]) || _ <- lists:seq(1, Rowcount)] || _ <- lists:seq(1, Rowcount)],
  % printList(ListofList),
  getidxFullPushSum(1, 1, round(math:sqrt(NumNodes)), ListofList),
  RPID = lists:nth(1, lists:nth(1, ListofList)),
  RPID ! {sw, 1, 1},
  supervisorPushSum(Rowcount*Rowcount)
  .
pushSumI2D(NumNodes) ->
  Rowcount =  round(math:sqrt(NumNodes)),
  ListofList = [[spawn(project2bonus, actorPushSum, [self(), Rowcount]) || _ <- lists:seq(1, Rowcount)] || _ <- lists:seq(1, Rowcount)],
  % printList(ListofList),
  getidxI2DPushSum(1, 1, round(math:sqrt(NumNodes)), ListofList),
  RPID = lists:nth(1, lists:nth(1, ListofList)),
  RPID ! {sw, 1, 1},
  supervisorPushSum(Rowcount*Rowcount)
  .
pushSumLine(NumNodes) ->
  Rowcount =  round(math:sqrt(NumNodes)),
  List = [spawn(project2bonus, actorPushSum, [self(), Rowcount]) || _ <- lists:seq(1, Rowcount*Rowcount)],
  % printList(List),
  getidxLinePushSum(1, Rowcount*Rowcount, List),
  RPID = lists:nth(1, List),
  RPID ! {sw, 1, 1},
  supervisorPushSum(Rowcount*Rowcount)
  .
run(NumNodes, Topology, Algorithm, DropPercent) ->
  case Algorithm of
    "gossip" ->
      case Topology of
        "2D" -> gossip2D(NumNodes, DropPercent);
        "full" -> gossipFull(NumNodes, DropPercent);
        "Imp3D" -> gossipI2D(NumNodes, DropPercent);
        "line" -> gossipLine(NumNodes, DropPercent)
      end;
    "push-sum" ->
      case Topology of
        "2D" -> pushSum2D(NumNodes);
        "full" -> pushSumFull(NumNodes);
        "Imp3D" -> pushSumI2D(NumNodes);
        "line" -> pushSumLine(NumNodes)
      end
  end.