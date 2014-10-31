-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]).
%-define(MAX_LINE_SIZE, 512).
%-define(TCP_OPTIONS, [list, {packet, line}, {active, false}, {reuseaddr, true}, {recbuf, ?MAX_LINE_SIZE}]).
-define(SOCKET_HEANDER_REGISTER, "RegisterApp").
-define(SOCKET_HEANDER_PUSH, "Push").
-define(SOCKET_HEANDER_HEARTBEAT, "HB").

-define(SEPERATOR_REGEXP, "<:>").
-define(All_PUSH, "all").
-define(END_OF_MESSAGE, "<EOM>").
%SOCKET PORT
-define(SOCKET_PORT, 9876).

-define(CODE_OK, "200").
-define(CODE_NULL_PARAM, "400").
-define(CODE_ERROT_COMMAND, "401").
-define(CODE_ERROR_DATA, "402").
-define(CODE_NO_DATA, "404").