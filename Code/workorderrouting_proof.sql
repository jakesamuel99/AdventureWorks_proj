-- This shows all the workorderrounting workorderids are only workorderids
-- that have been completed on the due date or later than the due date.


WITH count1 AS (
    SELECT COUNT(DISTINCT workorderid) AS count1
    FROM production.workorderrouting
),
count2 AS (
    SELECT COUNT(DISTINCT workorderid) AS count2
    FROM production.workorder
    WHERE enddate >= duedate
)

SELECT
	CASE
    	WHEN count1.count1 = count2.count2 THEN 'Equal'
   		ELSE 'Not Equal'
	END AS result,
	CASE
		WHEN count1.count1 = count2.count2 THEN count1.count1
   		ELSE NULL
	END AS count_value
FROM count1, count2;