-module(msg_app).

-behaviour(application).

%% Application callbacks
-export([start1/0, start_web/0, start/2, stop/1]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%% ===================================================================
%% Application callbacks
%% ===================================================================
start1() ->
	start(undefined,undefined).

start_web() ->
  msg_sup:start_link(),
  dao:start(),
	web_server:start().

start(_StartType, _StartArgs) ->
    msg_sup:start_link().

stop(_State) ->
    ok.



-ifdef(TEST).

simple_test() ->
    ok = application:start(msg),
    ?assertNot(undefined == whereis(msg_sup)).

-endif.