-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]).
%-define(MAX_LINE_SIZE, 512).
%-define(TCP_OPTIONS, [list, {packet, line}, {active, false}, {reuseaddr, true}, {recbuf, ?MAX_LINE_SIZE}]).
-define(SOCKET_HEANDER_REGISTER, "RegisterApp").
-define(SOCKET_HEANDER_PUSH, "Push").

-define(SEPERATOR_REGEXP, "<:>").
-define(All_PUSH, "all").
%SOCKET PORT
-define(SOCKET_PORT, 1234).