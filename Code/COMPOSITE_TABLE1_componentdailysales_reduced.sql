WITH date_series AS (
    SELECT
        d::date AS orderdate
    FROM
        generate_series(
            '2011-05-31'::date,  -- Start date
            '2014-05-30'::date,  -- End date
            '1 day'::interval    -- Interval (1 day)
        ) d
)

SELECT
    ds.orderdate,
    COALESCE(ROUND(SUM(c.subtotal), 0), 0) AS totalsalesvalue,
	COALESCE(ROUND(SUM(c.orderqty), 0), 0) AS totalorders
	
FROM
    date_series ds
LEFT JOIN (
    -- Your existing subquery with the joins and calculations
    SELECT
        SALES.SALESORDERDETAIL.salesorderid,
        SALES.SALESORDERDETAIL.salesorderdetailid,
        SALES.SALESORDERDETAIL.PRODUCTID,
        PRODUCTION.PRODUCTSUBCATEGORY.PRODUCTCATEGORYID,
        PRODUCTION.PRODUCT.PRODUCTSUBCATEGORYID,
        orderqty,
        unitprice,
        (orderqty * unitprice) AS subtotal,
        SALES.SALESORDERHEADER.territoryid,
        SALES.SALESTERRITORY.NAME,
        orderdate
    FROM
        SALES.SALESORDERDETAIL
    FULL OUTER JOIN SALES.SALESORDERHEADER ON
        SALES.SALESORDERDETAIL.SALESORDERID = SALES.SALESORDERHEADER.SALESORDERID
    FULL OUTER JOIN SALES.SALESTERRITORY ON
        SALES.SALESTERRITORY.TERRITORYID = SALES.SALESORDERHEADER.TERRITORYID
    JOIN PRODUCTION.PRODUCT ON
        SALES.SALESORDERDETAIL.PRODUCTID = PRODUCTION.PRODUCT.PRODUCTID
    JOIN PRODUCTION.PRODUCTSUBCATEGORY ON
        PRODUCTION.PRODUCT.PRODUCTSUBCATEGORYID = PRODUCTION.PRODUCTSUBCATEGORY.PRODUCTSUBCATEGORYID
    WHERE production.productsubcategory.productcategoryid = 2 AND production.productsubcategory.name IN ('Mountain Frames','Road Frames','Touring Frame') --Limits to components and the 3 most popular ones
) AS c
ON
    ds.orderdate = c.orderdate
GROUP BY
    ds.orderdate
ORDER BY
    ds.orderdate ASC;