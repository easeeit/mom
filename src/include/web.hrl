%% WEB PORT
-define(WEB_PORT, 8080).
%% url 分隔符
-define(PATH_SEPERATOR, "/").
%% 缺省页号
-define(PN, 1).
%% 缺省页大小
-define(RN, 10).

%% 返回码定义
%% 成功
-define(CODE_OK, 200).
%% 需要登录
-define(CODE_BAD_AUTH, 201).
%% 请求失败
-define(CODE_REQUEST_FAIL, 400).
%% 服务器错误
-define(CODE_SERVER_ERROR, 500).