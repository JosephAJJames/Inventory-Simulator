-module(main).
-export([start/1]).

inventory(Map) ->
   %Map = #{dough => 3, sauce => 0, cheese => 2, peperoni => 5}
   receive
      {add, Item, Amount} -> NewMap = maps:put(Item, maps:map_get(Item, Map) + Amount, Map),
         inventory(NewMap);
      {rmv, Item, Amount} -> 

      _ -> 
   end.

transaction({Type, Item, Amount}, Pid) ->
   Pid ! {Type, Item, Amount}.

transactionIterator([], _) ->
   [];
transactionIterator([Head | Tail], Pid) ->
   spawn(main, transaction, [Head, Pid]),
   transactionIterator(Tail, Pid).
   
start(List) -> 
   Ipid = spawn(main, inventory, []), %Inventory processId
   transactionIterator(List, Ipid).