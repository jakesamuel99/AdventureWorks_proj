SELECT 
    name,
    totalsales,
    ROUND((totalsales / totalsales_sum), 2) AS percentofsales
FROM (
    SELECT
		name,
        (salesytd + saleslastyear) AS totalsales,
        (SELECT SUM(salesytd + saleslastyear) FROM sales.salesterritory) AS totalsales_sum
    FROM sales.salesterritory
) AS sales_sum
ORDER BY percentofsales DESC