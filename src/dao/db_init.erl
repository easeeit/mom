-module(db_init).
-export([do_this_once/0]).

-include("../include/db.hrl").

do_this_once() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(shop, [{attributes, record_info(fields, shop)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
	mnesia:create_table(cost, [{attributes, record_info(fields, cost)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
    mnesia:create_table(design, [{attributes, record_info(fields, design)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
	mnesia:stop().
