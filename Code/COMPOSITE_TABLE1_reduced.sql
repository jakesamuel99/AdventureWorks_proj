-- Create a date series for the date range of your data
WITH DateSeries AS (
    SELECT generate_series(
        (SELECT MIN(orderdate) FROM SALES.salesorderheader), 
        (SELECT MAX(orderdate) FROM SALES.salesorderheader), 
        interval '1 day'
    )::date AS orderdate
)

-- Create a cross join with product categories to ensure every day and category is represented
, CategoryCrossJoin AS (
    SELECT DISTINCT
        ds.orderdate,
        pc.name AS categoryname
    FROM DateSeries ds
    CROSS JOIN production.productcategory pc
)

-- Your existing code here
, MainTable AS (
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
        (orderqty * unitprice) AS subtotal,
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
)

-- Now, add rows with orderqty = 0 for missing category entries
SELECT
    
		mt.salesorderid,
        mt.salesorderdetailid,
        mt.PRODUCTID,
        mt.PRODUCTCATEGORYID,
        mt.PRODUCTSUBCATEGORYID,
        ccj.categoryname,
        mt.subcategoryname,
        COALESCE(mt.orderqty, 0) AS orderqty, 
        mt.unitprice,
        (mt.orderqty * unitprice) AS subtotal,
        mt.territoryid,
        mt.territoryname,
        ccj.orderdate
		
FROM CategoryCrossJoin ccj
LEFT JOIN MainTable mt
    ON ccj.orderdate = mt.orderdate
    AND ccj.categoryname = mt.categoryname
ORDER BY ccj.orderdate;
