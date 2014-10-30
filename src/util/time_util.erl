-module(time_util).
-compile(export_all).

now_to_string() ->
  {{Y,M,D},{H,Mi,S}} = calendar:now_to_local_time(now()),
  Y1 = integer_to_list(Y),
  M1 = integer_to_list(M),
  D1 = integer_to_list(D),
  H1 = integer_to_list(H),
  Mi1 = integer_to_list(Mi),
  S1 = integer_to_list(S),
  Y1++"-"++len2(M1)++"-"++len2(D1)++" "++len2(H1)++":"++len2(Mi1)++":"++len2(S1).

len2(Str) when length(Str) =:= 1 -> "0"++Str;
len2(Str) -> Str.