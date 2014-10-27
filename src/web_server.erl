%% ---
%%  Excerpted from "Programming Erlang, Second Edition",
%%  published by The Pragmatic Bookshelf.
%%  Copyrights apply to this code. It may not be used to create training material, 
%%  courses, books, articles, and the like. Contact us if you are in doubt.
%%  We make no guarantees that this code is fit for any purpose. 
%%  Visit http://www.pragmaticprogrammer.com/titles/jaerlang2 for more book information.
%%---
-module(web_server).
-compile(export_all).

start() ->
    start(8877).

start_from_shell([PortAsAtom]) ->
    PortAsInt = list_to_integer(atom_to_list(PortAsAtom)),
    start(PortAsInt).
%%

start(Port) ->
    ok = application:start(crypto),
    ok = application:start(ranch),  
    ok = application:start(cowlib),
    ok = application:start(cowboy),
    N_acceptors = 100,
    Dispatch = cowboy_router:compile(
		 [
		  %% {URIHost, list({URIPath, Handler, Opts})}
		  {'_', [{'_', dispatch_handler, []}]}
		 ]),
    cowboy:start_http(web_server,
		      N_acceptors,
		      [{port, Port}],
		      [{env, [{dispatch, Dispatch}]}]
		     ),

    echo:me(<<"------------------- WEB SERVER START -------------------">>).

terminate(_Reason, _Req, _State) ->
    ok.
