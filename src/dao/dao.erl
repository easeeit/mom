-module(dao).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("../include/db.hrl").

start() ->
    mnesia:start(),
    mnesia:wait_for_tables([x_article,x_topic,x_comment], 20000).

stop() ->
  mnesia:stop().

select(x_article) ->
%	do(qlc:q([{X#shop.item, X#shop.quantity} || X <- mnesia:table(shop)])).
  do(qlc:q([{X} || X <- mnesia:table(x_article)])).

do(Q) ->
  F = fun() -> qlc:e(Q) end,
  {atomic, Val} = mnesia:transaction(F),
  Val.

insert(Rows) when is_list(Rows) ->
  F = fun() ->
    lists:foreach(fun mnesia:write/1, Rows)
  end,
  mnesia:transaction(F);
insert(Row) ->
  F = fun() ->
    mnesia:write(Row)
  end,
  mnesia:transaction(F).

%% 指定表的数据量
count(Table) ->
    case list(Table) of
        {error,Msg} -> {error,Msg};
        {ok,[]} -> 0;
        {ok,L} -> length(L)
    end.

%% 按条件查询指定表满足条件的数据的数量
count(Table,Where) ->
    case list(Table,Where) of
        {error,Msg} -> {error,Msg};
        {ok,[]} -> 0;
        {ok,L} -> length(L)
    end.


%% 查看指定Table中的所有数据
list(Table) ->
    F = fun() ->
        qlc:e(qlc:q([X||X<-mnesia:table(Table)]))
    end,
    {atomic,L} = mnesia:transaction(F),
    {ok,L}.

%% 按条件查询指定表满足条件的所有数据
list(Table,[]) -> list(Table);
list(Table,Where) ->
    case query_func(Table,Where) of
        {error,Msg} -> {error,Msg};
        {ok,F} ->
            {atomic,L} = mnesia:transaction(F),
            {ok,L}
    end.

%% 分页取表信息
%% @type Table = atom()
%% @type Offset = integer() > 0
%% @type Limit = integer() > 0
%% @spec list(site,1,20) -> [L] | {error,badarg} 
list(Table,Offset,Limit) ->
  echo:me([Table,Offset,Limit]),
    if 
        is_integer(Offset) and is_integer(Limit) and (Offset > 0) and (Limit > 0) -> 
            F=fun() ->
                  QH=qlc:q([X||X<-mnesia:table(Table)]),
                  Qc=qlc:cursor(QH), 
                  case Offset of
                      1 -> skip;
                      _ -> qlc:next_answers(Qc,Offset-1)
                  end,
                  qlc:next_answers(Qc,Limit)
            end,
            {atomic,L} = mnesia:transaction(F),
            {ok,L};
        true -> {error,badarg}
    end.
 
%% 按Where条件搜索分页取表信息
%% @type Table = atom()
%% @type Offset = integer() > 0
%% @type Limit = integer() > 0
%% @type Where = [{agent,Agent}] | [{creator,Creator}]
%% @spec list(site,1,20,[{agent,shopex}]) -> [L] | {error,badarg} 
list(Table,Offset,Limit,Where) ->
    if 
        is_integer(Offset) and is_integer(Limit) and (Offset > 0) and (Limit > 0) -> 
            case query_func(Table,Offset,Limit,Where) of
                {error,Msg} -> {error,Msg};
                {ok,F} ->
                    {atomic,L} = mnesia:transaction(F),
                    L
            end;
        true -> {error,badarg}
    end.

%% 查询方法 翻页使用
query_func(Table,Offset,Limit,Where) ->
    case query_cond(Table,Where) of
        {ok,QH} ->
            {ok,fun() ->
                  Qc=qlc:cursor(QH), 
                  case Offset of
                      1 -> skip;
                      _ -> qlc:next_answers(Qc,Offset-1)
                  end,
                  qlc:next_answers(Qc,Limit)
            end};
        {error,Msg} -> {error,Msg}
    end.

%% 查询方法(count使用)
query_func(Table,Where) ->
    case query_cond(Table,Where) of
        {ok,QH} ->
            {ok,fun() -> qlc:e(QH) end};
        {error,Msg} -> {error,Msg}
    end.

%% 查询商品(shop) 
query_cond(Table,Where) ->
    case Where of
            %% 按Item查询
            [{id,ID}] ->
                QH=qlc:q([X || X <- mnesia:table(Table),
                                    X#x_article.id =:= ID]),
                {ok,QH};
            [_] ->
                {error,badarg};
            [] ->
                QH=qlc:q([X || X <- mnesia:table(Table)]),
                {ok,QH}
        end;


%% 没有相关表的query_cond 都是报错的
query_cond(_,_) ->
    {error,badarg}.