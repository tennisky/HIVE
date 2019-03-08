---------------------------------------------------------------------------------------------------------
- VIEW定義
---------------------------------------------------------------------------------------------------------

-- 参照用VIEW定義
CREATE VIEW IF NOT EXISTS sep_logs_view_yyyy AS

-- sepログを参照するためにレコードに番号を振る
WITH 
sep_row AS(
SELECT 
	row_number() over() AS row_num,
	*
FROM
	Sep_log_yyyy
),

-- yyyy-mm-dd hh:mm:ss の形式にしてタイムスタンプ型に変換
ope_time AS(
	SELECT
		row_num,
		CAST(CONCAT(operation_time, ':00') AS TIMESTAMP) AS operation_time
	FROM(
		SELECT
			row_num,
			CASE
				WHEN locate(' ', reverse(operation_time), 1) == 5 
					THEN regexp_replace(operation_time, substr(operation_time, 1, 11), concat(substr(operation_time, 1, 11), '0'))
				ELSE operation_time
			END operation_time
		FROM(
			SELECT
				row_num,
				CASE
					WHEN locate(' ', operation_time, 1) == 10 and locate('-', operation_time, 6) == 7 
						THEN regexp_replace(operation_time, substr(operation_time, 1, 5), concat(substr(operation_time, 1, 5), '0'))
					WHEN locate(' ', operation_time, 1) == 10 and locate('-', operation_time, 6) == 8 
						THEN regexp_replace(operation_time, substr(operation_time, 1, 8), concat(substr(operation_time, 1, 8), '0'))
					ELSE operation_time
				END operation_time
			FROM(
				SELECT
					row_num,
					CASE
						WHEN locate(' ', operation_time, 1) == 11 THEN regexp_replace(operation_time, '/', '-')
						WHEN locate(' ', operation_time, 1) == 10 THEN regexp_replace(operation_time, '/', '-')
						WHEN locate(' ', operation_time, 1) == 9 THEN regexp_replace(operation_time, '/', '-0')
					END operation_time
				FROM
					sep_row
			) AS a
		) AS b 
	) as c
)

-- 対象のデータのみを取得
SELECT
	a.machine_name,
	a.target_name,
	a.target_address,
	a.app_name,
	a.window_title,
	a.operation,
	a.user_id,
	b.operation_time,
	a.etc
FROM
	sep_row a join ope_time b on (a.row_num = b.row_num)
;
