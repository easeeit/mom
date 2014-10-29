-module(main).
-export([start/0]).	

start() ->
	socket_server:start(8080).