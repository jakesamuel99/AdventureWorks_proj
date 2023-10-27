SELECT 
		workorder.workorderid,
		workorder.productid,
		workorder.scrappedqty,
		workorder.duedate,
		workorder.scrapreasonid,
		product.name,
		product.safetystocklevel,
		product.reorderpoint,
		product.standardcost,
		product.listprice,
		product.daystomanufacture,
		productsubcategory.productsubcategoryid,
		productsubcategory.name AS subcat_name,
	   CASE
           WHEN product.name ILIKE '%seat%' THEN 'Seat Assembly'
		   WHEN product.name ILIKE '%tube%' THEN 'Frame Tube'
		   WHEN product.name ILIKE '%caps%' THEN 'End Caps'
		   WHEN product.name ILIKE ANY (ARRAY['fork%', 'blade']) THEN 'Frame Component'
		   WHEN product.name ILIKE ANY (ARRAY['%hub%', '%bearing%']) THEN 'Hub Component'
		   WHEN product.name ILIKE ANY (ARRAY['chain stays', 'steerer', 'stem']) THEN 'Steering Component'
           ELSE productsubcategory.name
       END AS subcat_name_adj,
       CASE
           WHEN enddate <= duedate THEN TRUE -- duedate >= enddate is defined as on time
           ELSE FALSE
       END AS on_time,
	   CASE
           WHEN enddate > duedate THEN (enddate-duedate)
           ELSE NULL
       END AS days_late
	   
	   FROM production.workorder

LEFT JOIN production.product ON product.productid = workorder.productid

LEFT JOIN production.productsubcategory ON productsubcategory.productsubcategoryid = product.productsubcategoryid