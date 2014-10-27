-module(db).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").

-record(shop, {item, quantity, cost}).
-record(cost, {name, price}).
-record(design, {id, plan}).



do_this_once() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(shop, [{attributes, record_info(fields, shop)}]),
	mnesia:create_table(cost, [{attributes, record_info(fields, cost)}]),
    mnesia:create_table(design, [{attributes, record_info(fields, design)}]),
	mnesia:stop().

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