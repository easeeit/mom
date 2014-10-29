-record(shop, {item, quantity, cost}).
-record(cost, {name, price}).
-record(design, {id, plan}).

%%表存储策略
%%磁盘+内存,可从磁盘中恢复
-define(TABLE_STORAGE_POLICY_DISC, disc_copies).
%%仅磁盘
-define(TABLE_STORAGE_POLICY_DISC_ONLY, disc_only_copies).