-module(dao).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("../include/db.hrl").

start() ->
    mnesia:start(),
    mnesia:wait_for_tables([x_article,x_topic,x_comment], 20000).

select(x_article) ->
%	do(qlc:q([{X#shop.item, X#shop.quantity} || X <- mnesia:table(shop)])).
  do(qlc:q([{X} || X <- mnesia:table(x_article)])).

do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.

insert_shop(ID, Title, SubTitle) ->
	Row = #x_article{id=ID, title = Title, sub_title = SubTitle},
	F = fun() ->
			mnesia:write(Row)
		end,
	mnesia:transaction(F).

stop() ->
	mnesia:stop().