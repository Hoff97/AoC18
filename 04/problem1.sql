--﻿DROP VIEW IF EXISTS minutes_guard_max;

--DROP VIEW IF EXISTS guard_summed_times;

--DROP VIEW IF EXISTS guard_sleep_times;

--DROP MATERIALIZED VIEW IF EXISTS input_full;

--DROP VIEW IF EXISTS input_structured;

--DROP VIEW IF EXISTS input_sorted;

--DROP TABLE IF EXISTS input;



CREATE TABLE input (
	content text
);

COPY input FROM 'input.txt';

CREATE VIEW input_sorted AS 
	SELECT i.content,(SELECT COUNT(s.content) FROM input s WHERE s.content < i.content) as id FROM input i ORDER BY content;

CREATE VIEW input_structured AS (
	SELECT 
		id,
		substring(content from '[0-9]{4}-[0-9]{2}-[0-9]{2}') AS date,
		substring(content from '[0-9]{4}-[0-9]{2}-[0-9]{2} ([0-9]{2}:[0-9]{2})') AS time,
		substring(content from '([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2})') AS datetime,
		substring(content from '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:([0-9]{2})') AS minute,
		substring(content from '\[[A-Za-z0-9: -]+\] ([A-Za-z0-9 #]+)') AS description,
		substring(content from '#([0-9]+)') AS guard_id,
		(CASE WHEN substring(content from '(falls asleep)') = 'falls asleep' THEN 'asleep'
		      WHEN substring(content from '(wakes up)') = 'wakes up' THEN 'wakeup' ELSE 'starts' END) AS type
	FROM input_sorted
);
CREATE MATERIALIZED VIEW input_full AS (
	SELECT 
		s.id,
		s.date,
		s.time,
		s.minute,
		s.description,
		(select i.guard_id from input_structured i where i.guard_id IS NOT NULL AND i.datetime <= s.datetime order by datetime desc LIMIT 1) as guard_id,
		s.type
	FROM input_structured s
);

CREATE VIEW guard_sleep_times AS (
	SELECT
		a.id as id,
		a.guard_id as guard_id,
		a.minute::int as from_minute,
		b.minute::int as to_minute,
		a.date as date,
		(b.minute::int)-(a.minute::int) as duration
		from 
			input_full a, input_full b
		where a.id + 1 = b.id and a.date = b.date and a.type='asleep' and b.type='wakeup'
);

CREATE VIEW guard_summed_times AS (
	SELECT
		guard_id as guard_id,
		sum(duration) as dursum
		from guard_sleep_times
		group by guard_id
		order by dursum desc
);

CREATE VIEW minutes_guard_max AS (
	SELECT 
		num as minute,
		(SELECT
			count(st.date)
			FROM guard_sleep_times st
			where
			st.from_minute <= num and st.to_minute > num
			and st.guard_id = (select guard_id from guard_summed_times limit 1)
		) as count
	FROM generate_series(0, 59) num
	order by count desc
);

select (select guard_id::int from guard_summed_times limit 1)*(select minute from minutes_guard_max limit 1);
