-module(dao).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("../include/db.hrl").

start() ->
    mnesia:start(),
    mnesia:wait_for_tables([shop,cost,design], 20000).

select(shop) ->
	do(qlc:q([{X#shop.item, X#shop.quantity} || X <- mnesia:table(shop)])).

do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.

insert_shop(Name, Quantity, Cost) ->
	Row = #shop{item=Name, quantity = Quantity, cost = Cost},
	F = fun() ->
			mnesia:write(Row)
		end,
	mnesia:transaction(F).

stop() ->
	mnesia:stop().