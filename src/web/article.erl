-module(article).
-compile(export_all).

-include("../include/web.hrl").
-include("../include/db.hrl").

list([], Req) ->  list([?PN, ?RN], Req);
list([Pn | []], Req) ->  list([Pn, ?RN], Req);
list([Pn | [Rn]], Req) ->
  echo:me("article:list"),
  echo:me(Pn ++ Rn),
  Pn1 = list_to_integer(Pn),
  Rn1 = list_to_integer(Rn),
  case dao:list(x_article, ((Pn1 - 1) * Rn1) + 1, Rn1) of
    % 完成
    {ok, L} -> 
%      echo:me(L),
%      echo:me({struct,[{<<"article">>,format(L)}]}),
      Json = mochijson2:encode({struct,[{<<"article">>,format(L)}]}),
%      echo:me(Json),
      Json;
    % 错误
    {Status,Info} -> "error :" ++ atom_to_list(Status) ++ " " ++ atom_to_list(Info)
  end.

create(Arguments) -> "json data".

format(List) -> format(List, []).
format([], Results) -> Results;
format([H|T], Results) -> format(T, [json(H)|Results]).

json(#x_article{id=ID, title=Ti, sub_title=ST, content=C, source=Sou, type=Type, author=Author,
  status=Status,hits_count=HC,laud_count=LC,url=URL,original_url=OURL,create_time=CT} = R) ->
  {struct,[
    {<<"id">>,list_to_binary(ID)},
    {<<"title">>,list_to_binary(Ti)}, 
    {<<"sub_title">>,list_to_binary(ST)}, 
    {<<"url">>,list_to_binary(URL)}, 
    {<<"hits_count">>,HC}, 
    {<<"laud_count">>,LC}, 
    {<<"comment_count">>,0}, 
    {<<"create_time">>,list_to_binary(CT)}, 
    {<<"tag">>,list_to_binary(CT)}
  ]}.