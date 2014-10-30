-module(article_dao).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
-include("../include/db.hrl").

insert(#{}) -> {error, no_data};
insert(Row) when not is_record(Row, x_article) ->
  {error, error_type};
insert(Row) ->
  dao:insert(Row),
  {ok,done}.

test_data() ->
  [
    {x_article, "11111", "title1111","subtitle1111","content111", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "2222222", "title2222","subtitle222","content222", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "3333333", "title3333","subtitle33","content3333", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "44444444", "title4444","subtitle44","content444", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "55555", "title5555555","subtitle55","content555", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "66666", "title6666","subtitle66","content666", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "7777777", "title777777","subtitle77","content777", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "8888", "title888","subtitle88","content888", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "999999999", "title9999","subtitle99","content999", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "aaaaaaaaaa", "titleaaaa","subtitleaa","contentaa", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "bbbbbbbb", "titlebbbbb","subtitlebb","contentbbb", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()},
    {x_article, "xxxxxxx", "titlexxxx","subtitlexxx","contentxxx", "", 1, "", 1, 1000, 500, "http://baidu.com", "http://sohu.com",time_util:now_to_string()}
  ].