-module(db_init).
-export([do_this_once/0]).

-include("../include/db.hrl").

do_this_once() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(x_article, [{attributes, record_info(fields, x_article)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
	mnesia:create_table(x_topic, [{attributes, record_info(fields, x_topic)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_comment, [{attributes, record_info(fields, x_comment)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_tag, [{attributes, record_info(fields, x_tag)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_tag_relation, [{attributes, record_info(fields, x_tag_relation)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_product, [{attributes, record_info(fields, x_product)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_attention, [{attributes, record_info(fields, x_attention)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_schedule, [{attributes, record_info(fields, x_schedule)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_remind, [{attributes, record_info(fields, x_remind)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_message, [{attributes, record_info(fields, x_message)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_trade, [{attributes, record_info(fields, x_trade)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_price, [{attributes, record_info(fields, x_price)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_wish_list, [{attributes, record_info(fields, x_wish_list)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_user, [{attributes, record_info(fields, x_user)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_user_config, [{attributes, record_info(fields, x_user_config)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_dynamic, [{attributes, record_info(fields, x_dynamic)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_friend_request, [{attributes, record_info(fields, x_friend_request)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_friend, [{attributes, record_info(fields, x_friend)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
  mnesia:create_table(x_praise, [{attributes, record_info(fields, x_praise)},{?TABLE_STORAGE_POLICY_DISC,[node()]}]),
	mnesia:stop().
