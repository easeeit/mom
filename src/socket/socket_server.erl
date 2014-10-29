-module(socket_server).

-export([start/0]).

-include("../include/socket.hrl").

start() ->
  start(?SOCKET_PORT).

start(Port) ->
  Pid = spawn(fun() -> socket_handler:manage_clients([]) end),
  register(client_manager, Pid),
  {ok, LSocket} = gen_tcp:listen(Port, ?TCP_OPTIONS),
  do_accept(LSocket).

do_accept(LSocket) ->
  {ok, Socket} = gen_tcp:accept(LSocket),
  spawn(fun() -> socket_handler:handle_client(Socket) end),
  client_manager ! {connect, Socket},
  do_accept(LSocket).

