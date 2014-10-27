-module(dispatch_handler).
-compile(export_all).

init(Req, Opts) ->
    handle(Req, Opts).

handle(Req, State) ->
    Path = cowboy_req:path(Req),
    echo:me("REQUEST PATH:"++binary_to_list(Path)),
    handle1(Path, Req, State).
handle1(<<"/cgi">>, Req, State) ->
%    echo:me(<<"qqqqqqqqqqqqqqqqqqqqqqqqqqqq">>),
    echo:me(cowboy_req:parse_qs(Req)),
    Args = cowboy_req:parse_qs(Req),
    {ok, Bin, Req2} = cowboy_req:body(Req),
    Val = mochijson2:decode(Bin),
    Response = call(Args, Val),
    Json = mochijson2:encode(Response),
    Req3 = cowboy_req:reply(200, [], Json, Req2),
    {ok, Req3, State};
handle1(Path, Req, State) ->
%    echo:me(<<"99999999999999999999">>),
    Response = read_file(Path),
    Req1 = cowboy_req:reply(200, [], Response, Req),
    {ok, Req1, State}.

call([{<<"mod">>,MB},{<<"func">>,FB}], X) ->
%    echo:me(<<"wwwwwwwwwwwwwwwwww">>),
    Mod = list_to_atom(binary_to_list(MB)),
    Func = list_to_atom(binary_to_list(FB)),
    apply(Mod, Func, [X]).

read_file(Path) ->
%    echo:me(<<"ffffffffffffffffffffffff">>),
    File = [$.|binary_to_list(Path)],
    case file:read_file(File) of
	{ok, Bin} -> Bin;
	_ -> ["<pre>cannot read:", File, "</pre>"]
    end.

