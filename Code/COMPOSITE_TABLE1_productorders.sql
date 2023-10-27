SELECT
	Purchasing.PurchaseOrderHeader.purchaseorderid,
	Purchasing.purchaseorderdetail.purchaseorderdetailid,
	Purchasing.purchaseorderdetail.productid,
	Purchasing.PurchaseOrderHeader.orderdate,
	Purchasing.Vendor.name AS supplier_name,
	Sales.SalesTerritory.name AS supplier_region

FROM Purchasing.PurchaseOrderHeader

LEFT JOIN Purchasing.Vendor
	ON Purchasing.Vendor.BusinessEntityID = Purchasing.PurchaseOrderHeader.VendorID
	
LEFT JOIN Person.BusinessEntityAddress
	ON Person.BusinessEntityAddress.BusinessentityID = Purchasing.Vendor.BusinessentityID

LEFT JOIN Person.Address
	ON Person.Address.AddressID = Person.BusinessEntityAddress.AddressID
	
LEFT JOIN Person.StateProvince
	ON Person.StateProvince.StateProvinceID = Person.Address.StateProvinceID
	
LEFT JOIN Sales.SalesTerritory
	ON Sales.SalesTerritory.TerritoryID = Person.StateProvince.TerritoryID
	
LEFT JOIN Purchasing.purchaseorderdetail 
	ON Purchasing.purchaseorderdetail.purchaseorderid = Purchasing.PurchaseOrderHeader.purchaseorderid