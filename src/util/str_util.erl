-module(str_util).
-export([remove_prefix/2]).

remove_prefix([],_) -> [];
remove_prefix(Str,[]) -> Str;
remove_prefix(Str, Prefix) ->
  re:replace(Str, Prefix, "", [{return, list}]).
