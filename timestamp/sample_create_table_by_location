---------------------------------------------------------------------------------------------------------
- テーブル定義 
---------------------------------------------------------------------------------------------------------

-- HDFSを参照し、HIVEテーブルを作成
CREATE TABLE IF NOT EXISTS Sep_log_yyyy(
  machine_name STRING, 
  target_name STRING, 
  target_address STRING, 
  app_name STRING, 
  window_title STRING, 
  operation STRING, 
  user_id STRING,
  operation_time STRING,
  etc STRING
)
row format delimited fields terminated by ',' lines terminated by '\n'
location '/user/admin/'
;
