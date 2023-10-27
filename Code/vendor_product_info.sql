--This shouls the subcategories that we have information on from the purhcasing vendors

--We do not have vendor information of the bikes and bike frames...

SELECT DISTINCT(Production.productsubcategory.name) FROM purchasing.productvendor
	LEFT JOIN Production.product ON product.productid = productvendor.productid
	LEFT JOIN Production.productsubcategory ON productsubcategory.productsubcategoryid = product.productsubcategoryid
WHERE production.product.productsubcategoryid IS NOT NULL

ORDER BY Production.productsubcategory.name