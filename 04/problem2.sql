CREATE VIEW guards AS (
	SELECT DISTINCT guard_id
		FROM input_full
);

CREATE VIEW minutes_guard_all AS (
	SELECT 
		num as minute,
		(SELECT
			count(st.date)
			FROM guard_sleep_times st
			where
			st.from_minute <= num and st.to_minute > num
			and st.guard_id = g.guard_id
		) as count,
		g.guard_id
	FROM 
		generate_series(0, 59) num,
		guards g
	order by count desc
);

select minute*(guard_id::int) from minutes_guard_all limit 1;