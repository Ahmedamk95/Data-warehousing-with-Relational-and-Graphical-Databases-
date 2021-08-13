select b.ProductKey, d.EmployeeKey, a.OrderID, (DiscountPercent * a.UnitPrice) as DiscountPrice, (a.UnitPrice - (DiscountPercent * a.UnitPrice)) as DiscountedUnitPrice, b.ProductID, b.ProductName,
c.CustomerID, (d.FirstName  +  d.LastName) as EmployeeName, e.ShipperID, e.CompanyName from [NORTHWIND].dbo.Orders c, [DimDiscount] a, [DimProduct] b, [DimEmployees] d, [DimShippers] e
where a.UnitPrice=b.UnitPrice and a.OrderID=c.OrderID and c.EmployeeID=d.EmployeeID and e.ShipperID=c.ShipVia


select c.CustomerID, a.OrderID from [NORTHWIND].dbo.Orders c, [DimDiscount] a where a.OrderID=c.OrderID

select a.DiscountKey, e.ShipperKey, b.ProductKey, d.EmployeeKey, a.OrderID, (DiscountPercent * a.UnitPrice) as DiscountPrice, (a.UnitPrice - (DiscountPercent * a.UnitPrice)) as DiscountedUnitPrice, b.ProductID, b.ProductName,
c.CustomerID, (d.FirstName  +  d.LastName) as EmployeeName, e.ShipperID, e.CompanyName from [NORTHWIND].dbo.Orders c, [DimDiscount] a, [DimProduct] b, [DimEmployees] d, [DimShippers] e
where a.UnitPrice=b.UnitPrice and a.OrderID=c.OrderID and c.EmployeeID=d.EmployeeID and e.ShipperID=c.ShipVia


CREATE TABLE Customer (name varchar(80) Collate SQL_Latin1_General_CP1_CI_AS)