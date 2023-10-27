WITH t1 AS (
    SELECT 
        workorder.workorderid,
        workorder.productid,
        workorder.scrappedqty,
        workorder.duedate,
        workorder.scrapreasonid,
        product.name,
        product.standardcost,
        product.listprice,
        CASE
            WHEN product.name ILIKE '%seat%' THEN 'Seat Assembly'
            WHEN product.name ILIKE '%tube%' THEN 'Frame Tube'
            WHEN product.name ILIKE '%caps%' THEN 'End Caps'
            WHEN product.name ILIKE ANY (ARRAY['fork%', 'blade']) THEN 'Frame Component'
            WHEN product.name ILIKE ANY (ARRAY['%hub%', '%bearing%']) THEN 'Hub Component'
            WHEN product.name ILIKE ANY (ARRAY['chain stays', 'steerer', 'stem']) THEN 'Steering Component'
            ELSE productsubcategory.name
        END AS subcat_name_adj
    FROM production.workorder
    LEFT JOIN production.product ON product.productid = workorder.productid
    LEFT JOIN production.productsubcategory ON productsubcategory.productsubcategoryid = product.productsubcategoryid
), t2 AS (SELECT *,
		  	CASE
            	WHEN (standardcost = 0) AND (name ILIKE ANY (ARRAY['mountain end caps', 'road end caps', 'touring end caps'])) THEN 5
		  		WHEN (standardcost = 0) AND (name ILIKE ANY (ARRAY['seat tube', 'seat stays'])) THEN 30
		  		WHEN (standardcost = 0) AND (name ILIKE ANY (ARRAY['bb ball bearing', 'hl hub', 'll hub'])) THEN 12
		  		WHEN (standardcost = 0) AND (name ILIKE ANY (ARRAY['down tube', 'head tube', 'top tube', 'handlebar tube'])) THEN 30
		 		WHEN (standardcost = 0) AND (name ILIKE ANY (ARRAY['chain stays', 'steerer', 'stem'])) THEN 20
		  		WHEN (standardcost = 0) AND (name ILIKE ANY (ARRAY['blade', 'fork crown', 'fork end'])) THEN 20
            	ELSE standardcost
       		END AS adjusted_cost
		 FROM t1)

SELECT *, scrappedqty*adjusted_cost AS total_scrapped_cost
FROM t2

WHERE scrappedqty > 0

ORDER BY total_scrapped_cost DESC
