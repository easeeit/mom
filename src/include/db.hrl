%%表存储策略
%%磁盘+内存,可从磁盘中恢复
-define(TABLE_STORAGE_POLICY_DISC, disc_copies).
%%仅磁盘
-define(TABLE_STORAGE_POLICY_DISC_ONLY, disc_only_copies).

-record(x_article, {id, title, sub_title, content, source, type, author, status, hits_count, laud_count, url, original_url, create_time}).
-record(x_topic, {id, title, content, status, platform, user_id, laud_count, create_time}).
-record(x_comment, {id, subject_type, subject_id, content, status, laud_count, quote_list, user_id, nickname, user_ip, user_location, create_time}).
-record(x_tag, {id, name, create_time}).
-record(x_tag_relation, {id, tag_id, subject_type, subject_id, create_time}).
-record(x_product, {id, name_cn, name_en, producer, publisher, platform, type, attention_count, score, score_time, laud_count, player_number, introduction, website, screenshot_list, create_time}).
-record(x_attention, {id, product_id, user_id, create_time}).
-record(x_schedule, {id, product_id, area, language, timetomarket, status, create_time}).
-record(x_remind, {id, user_id, schedule_id, create_time}).
-record(x_message, {id, type, status, content, sender_id, receiver_id, create_time}).
-record(x_trade, {id, product_name, mode, status, price, platform, version, language, quality, integrity, attachment, description, remark, user_id, phone, area, create_time}).
-record(x_price, {id, product_id, seller, price, price_date, url, create_time, update_time}).
-record(x_wish_list, {id, user_id, product_id, create_time}).
-record(x_user, {id, openid, nickname, source, score, birthday, name, gender, phone, email, address, signature, logo_url, last_login_time, create_time}).
-record(x_user_config, {id, user_id, attention_scope, wish_scope, create_time, update_time}).
-record(x_dynamic, {id, user_id, type, data_id, create_time}).
-record(x_friend_request, {id, from_user_id, to_user_id, status, create_time}).
-record(x_friend, {id, user_id1, user_id2, create_time}).
-record(x_praise, {id, user_id, subject_id, subject_type}).