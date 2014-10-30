-module(socket_handler).

-import(string,[right/2,left/2,len/1,str/2,sub_string/3,substr/2]).

-export([handle_client/1,manage_clients/1,delete_list/2]).

-include("../include/socket.hrl").

handle_client(Socket) ->
  case gen_tcp:recv(Socket, 0) of
    {ok, Data} ->
      client_manager ! {data, Data, Socket},
      handle_client(Socket);
    {error, closed} ->
      client_manager ! {disconnect, Socket}
  end.

manage_clients(UserSocketList) ->
  receive
    {connect, _Socket} ->
      NewUserSocketList = UserSocketList;
    {disconnect, Socket} ->
      %从用户连接列表中删除断开的连接
      List_to_delete = [{AppID, UserID,So} || {AppID, UserID, So} <- UserSocketList, So =:= Socket],
      NewUserSocketList = delete_list(UserSocketList, List_to_delete);
%      echo:me(NewUserSocketList);
    {data, Data, Socket} ->
      %% 二进制串 转 list
      Str = binary:bin_to_list(Data),
      %注册
      {_Status, _Socket, NewUserSocketList} = analyse_heander(Str, Socket, UserSocketList),
%      echo:me(NewUserSocketList)
      echo:me(length(NewUserSocketList))
      %广播
      %send_return(Sockets, Data),
  end,
  manage_clients(NewUserSocketList).

%%解析收到的数据串
analyse_heander([], _Socket, _List) -> {nodata, _Socket, _List};
analyse_heander(DataStr, Socket, UserSocketList) ->
  %%根据分割符,分解成数组
  [Command | Arguments] = re:split(DataStr, ?SEPERATOR_REGEXP, [{return, list}]),
%  echo:me(Command),
  case Command of
    ?SOCKET_HEANDER_REGISTER ->
  	  command_register(Arguments, Socket, UserSocketList);    
    ?SOCKET_HEANDER_PUSH -> 
      {Status, So, NewList} = command_push(Arguments, Socket, UserSocketList),
      echo:me(Status),
      {Status, So, NewList};
    _Other -> 
      command_error(Socket, UserSocketList)
  end.

%%终端注册应用 
%%客户端需要发送:RegisterApp||app标识::用户标识,
%%例如:"RegisterApp||jiejie::293485729",其中jiejie是应用标识,293485729是用户标识
command_register([], Socket,_UserSocketList) -> 
  send_return({Socket, ?CODE_NULL_PARAM}),
  {no_register_data, Socket,_UserSocketList};
command_register([_AppID | []], Socket,_UserSocketList) -> 
  send_return({Socket, ?CODE_NULL_PARAM}),
  {no_userid, Socket,_UserSocketList};  
command_register([AppID | [UserID | _]],Socket,UserSocketList) ->
%  echo:me(AppID),
%  echo:me(UserID),
  send_return({Socket, ?CODE_OK}),
  {ok, Socket, [{list_to_atom(AppID), list_to_atom(AppID++UserID) , Socket} | UserSocketList]}.

%%推送消息, 参数中的Socket 是,发送消息者的Socket
command_push([], Socket, _UserSocketList) ->
  send_return({Socket, ?CODE_NULL_PARAM}),
  {no_push_data, Socket, _UserSocketList};
command_push([_UserID | []], Socket, _UserSocketList) ->
  send_return({Socket, ?CODE_ERROR_DATA}),
  {no_msg, Socket, _UserSocketList};
command_push([UserID | [MsgData | _]], Socket, UserSocketList) ->
  echo:me("user : "++UserID ++ " , msg : "++MsgData),
  push_data(Socket, [{So, MsgData} || {_AppID, UID, So} <- UserSocketList, 
  		                                (UID =:= list_to_atom(UserID)) or (right(UserID,len(?All_PUSH)) =:= ?All_PUSH) ]),
  {ok, Socket, UserSocketList}.

command_error(Socket, _UserSocketList) ->
  send_return({Socket, ?CODE_ERROT_COMMAND}),
  {error_header, Socket, _UserSocketList}.

push_data(SrcSocket, []) -> 
  % 返回给发送方404
  send_return({SrcSocket, ?CODE_NO_DATA});
push_data(SrcSocket, TargetList) ->
  lists:foreach(fun(P) ->send_data(P) end , TargetList),
  send_return({SrcSocket, ?CODE_OK}).

send_return({Socket, Data}) ->
  echo:me("send_return : "++Data),
  gen_tcp:send(Socket, Data++?END_OF_MESSAGE).

send_data({Socket, Data}) ->
  echo:me("send_data : "++Data),
  gen_tcp:send(Socket, Data).

%%删除子列表
delete_list(BaseList, []) -> BaseList;
delete_list(BaseList, [H | T]) ->
  delete_list(lists:delete(H, BaseList), T).
