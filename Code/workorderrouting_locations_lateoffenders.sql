-- Shows each location ID and the biggest offenders of starting and finishing late

WITH t1 AS
(SELECT 
    *,
    CASE
        WHEN actualstartdate > scheduledstartdate THEN (actualstartdate - scheduledstartdate)
        ELSE NULL
    END AS days_start_late,
    CASE
        WHEN actualenddate > scheduledenddate THEN (actualenddate - scheduledenddate)
        ELSE NULL
    END AS days_end_late
FROM production.workorderrouting)

SELECT
	locationid,
	COUNT(days_start_late) AS freq_startlate,
	COUNT(days_end_late) AS freq_endlate,
	INTERVAL '1 day' * ROUND(AVG(EXTRACT(EPOCH FROM days_start_late) / 86400)) AS avgdayslate_startdate,
    INTERVAL '1 day' * ROUND(AVG(EXTRACT(EPOCH FROM days_end_late) / 86400)) AS avgdayslate_enddate

FROM t1

GROUP BY locationid
ORDER BY locationid;