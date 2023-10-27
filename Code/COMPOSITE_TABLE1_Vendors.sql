SELECT 
	Person.BusinessEntityAddress.BusinessentityID,
	Purchasing.Vendor.name,
	Sales.SalesTerritory.name

FROM Purchasing.Vendor

LEFT JOIN Person.BusinessEntityAddress
	ON Person.BusinessEntityAddress.BusinessentityID = Purchasing.Vendor.BusinessentityID

LEFT JOIN Person.Address
	ON Person.Address.AddressID = Person.BusinessEntityAddress.AddressID
	
LEFT JOIN Person.StateProvince
	ON Person.StateProvince.StateProvinceID = Person.Address.StateProvinceID
	
LEFT JOIN Sales.SalesTerritory
	ON Sales.SalesTerritory.TerritoryID = Person.StateProvince.TerritoryID
	
ORDER BY Sales.SalesTerritory.name