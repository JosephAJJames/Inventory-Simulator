-module(main).
-export([start/1, inventory/1, transaction/2]).

inventory(Map) ->
   receive
      {add, Item, Amount} -> NewMap = maps:put(Item, maps:get(Item, Map) + Amount, Map),
         io:format("Transaction Complete~n"),
         inventory(NewMap);
      {rmv, Item, Amount} ->
         NewAmount = maps:get(Item, Map) - Amount,
         if NewAmount < 0 -> 
               io:format("Stock can't go below 0~n"),
               inventory(Map);
         true ->
               NewMap = maps:put(Item, maps:get(Item, Map) - Amount, Map),
               io:format("Transaction Complete~n"),
               inventory(NewMap)
         end;
      _ -> io:format("Wrong Format~n")
   end.

transaction({Type, Item, Amount}, Pid) ->
   Pid ! {Type, Item, Amount}.

transactionIterator([], _) ->
   [];
transactionIterator([Head | Tail], Pid) ->
   spawn(main, transaction, [Head, Pid]),
   transactionIterator(Tail, Pid).
   
start(List) -> 
   Map = #{dough => 3, sauce => 0, cheese => 2, peperoni => 5},
   Ipid = spawn(main, inventory, [Map]), %Inventory processId
   transactionIterator(List, Ipid).