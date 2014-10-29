%% 业务分发器

-module(dispatcher).
-compile(export_all).

-include("../include/web.hrl").

handle(<<"/cgi">>, Req, State) ->
  echo:me(cowboy_req:parse_qs(Req)),
  Args = cowboy_req:parse_qs(Req),
  {ok, Bin, Req2} = cowboy_req:body(Req),
  Val = mochijson2:decode(Bin),
  Response = call(Args, Val),
  Json = mochijson2:encode(Response),
  Req3 = cowboy_req:reply(200, [], Json, Req2),
  {ok, Req3, State};
handle(Path, Req, State) ->
  {ReqType, Response} = read_file(Path),
%  echo:me(ReqType),
  Req1 = cowboy_req:reply(200, [], Response, Req),
  {ok, Req1, State}.

call([{<<"mod">>,MB},{<<"func">>,FB}], X) ->
  Mod = list_to_atom(binary_to_list(MB)),
  Func = list_to_atom(binary_to_list(FB)),
  apply(Mod, Func, [X]).

read_file(Path) ->
  File = [$.|binary_to_list(Path)],
  case file:read_file(File) of
    {ok, Bin} -> {page, Bin};
    _ -> 
      %% 删除Path串中最左边的"/"    
      Path1 = str_util:remove_prefix(Path, ?PATH_SEPERATOR),
      %% 分发模块 / 方法
      ReturnValue = dispatch_module_method(re:split(Path1,?PATH_SEPERATOR,[{return, list}])),
      {api, ReturnValue}
  end.

dispatch_module_method([]) -> "400";
dispatch_module_method([_Module | []]) -> "401";
dispatch_module_method([Module | [Method | Arguments]]) ->
  %% 反射调用 Module:Method(Arguments)
  try apply(list_to_atom(Module), list_to_atom(Method), [Arguments])
  catch
    throw:_X -> "502";
    error:_X -> "501";
    exit:_X  -> "500"
  end.