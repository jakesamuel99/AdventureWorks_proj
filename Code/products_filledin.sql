SELECT *
FROM (
    SELECT
        *,
        COALESCE(
            CASE
                WHEN name ILIKE '%saddle%' THEN 15
                WHEN name ILIKE '%tube%' THEN 37
                WHEN name ILIKE '%cap%' THEN 19
				WHEN name ILIKE '%nut%' OR name ILIKE '%bolt%' OR name ILIKE '%washer%' THEN 38
				WHEN name ILIKE '%metal%' THEN 39
                ELSE NULL -- Adjust this if needed, depending on your desired fallback value
            END,
            productsubcategoryid
        ) AS modified_productsubcategoryid
    FROM production.product
) AS subquery
WHERE modified_productsubcategoryid IS NULL;


--tube