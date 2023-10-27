WITH t1 AS (SELECT 
				workorder.workorderid,
				workorder.duedate,
				workorder.productid,
				product.name,
				product.safetystocklevel,
				product.reorderpoint,
				product.standardcost,
				product.listprice,
				product.daystomanufacture,
				(enddate - startdate) AS manufacture_time,
				CASE
				   WHEN product.name ILIKE '%seat%' THEN 'Seat Assembly'
				   WHEN product.name ILIKE '%tube%' THEN 'Frame Tube'
				   WHEN product.name ILIKE '%caps%' THEN 'End Caps'
				   WHEN product.name ILIKE ANY(ARRAY['fork%', 'blade']) THEN 'Frame Component'
				   WHEN product.name ILIKE ANY(ARRAY['%hub%', '%bearing%']) THEN 'Hub Component'
				   WHEN product.name ILIKE ANY(ARRAY['chain stays', 'steerer', 'stem']) THEN 'Steering Component'
				   ELSE productsubcategory.name
			   END AS subcategory_adj
		
			FROM production.workorder

			LEFT JOIN production.product ON product.productid = workorder.productid

			LEFT JOIN production.productsubcategory ON productsubcategory.productsubcategoryid = product.productsubcategoryid),
t2 AS (
    SELECT *
    FROM t1
    WHERE duedate >= '2013-01-01'::date)


SELECT
    subcategory_adj,
    CEIL(EXTRACT(EPOCH FROM AVG(manufacture_time)) / 86400) * INTERVAL '1 day' AS rounded_avg_manufacture_time,
    CASE
        WHEN STDDEV(EXTRACT(EPOCH FROM manufacture_time)) > 0
        THEN CEIL(STDDEV(EXTRACT(EPOCH FROM manufacture_time)) / 86400) * INTERVAL '1 day'
        ELSE NULL
    END AS rounded_stddev_manufacture_time,
    MIN(manufacture_time) AS min_days,
    MAX(manufacture_time) AS max_days
FROM t1
GROUP BY subcategory_adj;
