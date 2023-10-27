SELECT 
	subcategoryname,
	c.productid,
	averageleadtime
	
FROM (
SELECT
	SALES.SALESORDERDETAIL.salesorderid,
	SALES.SALESORDERDETAIL.salesorderdetailid,
	SALES.SALESORDERDETAIL.PRODUCTID,
	PRODUCTION.PRODUCTSUBCATEGORY.PRODUCTCATEGORYID,
	PRODUCTION.PRODUCT.PRODUCTSUBCATEGORYID,
	production.productcategory.name AS categoryname,
	production.productsubcategory.name AS subcategoryname,
	orderqty, 
	unitprice,
	(orderqty*unitprice) AS subtotal,
	SALES.SALESORDERHEADER.territoryid,
	SALES.SALESTERRITORY.NAME AS territoryname,
	orderdate
FROM SALES.SALESORDERDETAIL

FULL OUTER JOIN SALES.SALESORDERHEADER ON
	SALES.SALESORDERDETAIL.SALESORDERID = SALES.SALESORDERHEADER.SALESORDERID
	
FULL OUTER JOIN SALES.SALESTERRITORY ON
	SALES.SALESTERRITORY.TERRITORYID = SALES.SALESORDERHEADER.TERRITORYID
	
JOIN PRODUCTION.PRODUCT ON
	SALES.SALESORDERDETAIL.PRODUCTID = PRODUCTION.PRODUCT.PRODUCTID
	
JOIN PRODUCTION.PRODUCTSUBCATEGORY ON
	PRODUCTION.PRODUCT.PRODUCTSUBCATEGORYID = PRODUCTION.PRODUCTSUBCATEGORY.PRODUCTSUBCATEGORYID
	
JOIN PRODUCTION.productcategory ON 
	production.productcategory.productcategoryid = PRODUCTION.PRODUCTSUBCATEGORY.PRODUCTCATEGORYID

WHERE (production.productsubcategory.productcategoryid = 1)
   OR (production.productsubcategory.name IN ('Mountain Frames', 'Road Frames', 'Touring Frame'))
 --Limits to bike and the 3 most popular components
) AS c

LEFT JOIN purchasing.productvendor ON 
	purchasing.productvendor.productid = c.productid