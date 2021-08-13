
use northwindDW
use NORTHWIND
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------NorthwindDW database (1)Fact and Dimensions--------------------------------------------
use northwindDW
create table Inventory_Fact(  
InventoryKey int not null identity(1,1) primary key, 
ProductKey int not null,
ProductName nvarchar(40) not null,
CategoryKey int not null,
CategoryName nvarchar(15) not null,
Description ntext null,
SupplierKey int not null,
SupplierCompany nvarchar(40) not null,
AvailableStockPrice int null,
StockOnOrderPrice int null,
);
----------------------------------------------------------------------------------------------------------------------
Create table DimSuppliers(
SupplierKey int not null identity(1,1) primary key,
SupplierID int not null,
CompanyName nvarchar(40) not null,
ContactName nvarchar(30) null,
ContactTitle nvarchar(30) null,
Address nvarchar(60) null,
City nvarchar(15) null,
Region nvarchar(15) null,
PostalCode nvarchar(10) null,
Country nvarchar(15) null,
Phone nvarchar(24) null,
Fax nvarchar(24) null,
HomePage ntext null
);
--------------------------------------------------------------------------------------------------------------------------
Create table DimProduct(
ProductKey int identity(1,1) not null primary key,
ProductID int not null,
ProductName nvarchar(40) not null,
SupplierID int null,
CategoryID int null,
QuantityPerUnit nvarchar(20) null,
UnitPrice money null,
UnitsInStock smallint null,
UnitsOnOrder smallint null,
ReorderLevel smallint null,
Discontinued bit not null
)
----------------------------------------------------------------------------------------------------------------------------
Create Table DimCategories(
CategoryKey int not null identity(1,1) primary key,
CategoryID int not null,
CategoryName nvarchar(15) not null,
Description ntext null,
Picture image null
);
-----------------------------------------------------------------------------------------------------------------------------
alter table Inventory_Fact add constraint FK_Inventory_Fact_DimSuppliers foreign key(SupplierKey)
references DimSuppliers(SupplierKey);
alter  table Inventory_Fact add constraint FK_Inventory_Fact_DimProduct foreign key(ProductKey)
references DimProduct(ProductKey);
alter table Inventory_Fact add constraint FK_Inventory_Fact_DimCategories foreign key(CategoryKey)
references DimCategories(CategoryKey);
-----------------------------------------------------------------------------------------------------------------------------
select * from Inventory_Fact
select * from DimProduct
select * from DimSuppliers
select * from DimCategories
-----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------Fact Query-------------------------------------------------------------------
select a.ProductKey, a.ProductID, a.ProductName, b.SupplierKey, b.SupplierID, b.CompanyName, (UnitPrice * UnitsInStock) as AvailableStockPrice, (UnitPrice * UnitsOnOrder) as StockOnOrderPrice
from DimProduct a, [DimSuppliers] b where a.SupplierID=b.SupplierID



select a.ProductID, a.ProductName, c.CategoryKey, c.CategoryName, c.Description from DimProduct a, [DimCategories] c where a.CategoryID=c.CategoryID
-----------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------NorthwindDW database (2)Fact and Dimensions--------------------------------------------
Create table DimDate(
DateKey int identity(1,1) not null primary key,
OrderDate datetime null,
RequiredDate datetime null,
ShippedDate datetime null
)

Create table DimEmployees(
EmployeeKey int identity(1,1) not null primary key,
EmployeeID int not null,
LastName nvarchar(20) not null,
FirstName nvarchar(10) not null,
Title nvarchar(30) null,
TitleOfCourtesy nvarchar(25) null,
Address nvarchar(60) null,
City nvarchar(15) null,
Region nvarchar(15) null,
PostalCode nvarchar(10) null,
Country nvarchar(15) null,
HomePhone nvarchar(24) null,
Extension nvarchar(4) null,
Notes ntext null,
ReportsTo int null,
)

Create table DimShippers(
ShipperKey int not null identity(1,1) primary key,
ShipperID int null,
CompanyName nvarchar(40) not null,
Phone nvarchar(24) null
)
Create table DimDiscount(
DiscountKey int not null identity(1,1) primary key,
OrderID int not null,
UnitPrice money not null,
DiscountPercent real not null
);

Create table Orders_Fact(
	OrderKey int not null identity(1,1) primary key,
	EmployeeKey int not null,
	DateKey int not null,
	ProductKey int not null,
	ShipperKey int not null,
	DiscountKey int not null,
	OrderID int not null,
	OrderDate datetime null,
	RequiredDate datetime null,
	EmployeeName nvarchar(100) not null,
	ProductName nvarchar(40) not null,
	ShippingCompany nvarchar(40) not null,
	ShippedDate datetime null,
	DiscountPrice real not null,
	DiscountedUnitPrice real not null
	);
alter table Orders_Fact add constraint FK_Orders_Fact_DimDate foreign key(DateKey)
references DimDate(DateKey);
alter table Orders_Fact add constraint FK_Orders_Fact_DimEmployees foreign key(EmployeeKey)
references DimEmployees(EmployeeKey);
alter table Orders_Fact add constraint FK_Orders_Fact_DimShippers foreign key(ShipperKey)
references DimShippers(ShipperKey);
alter table Orders_Fact add constraint FK_Orders_Fact_DimProduct foreign key(ProductKey)
references DimProduct(ProductKey);
alter table Orders_Fact add constraint FK_Orders_Fact_DimDiscount foreign key(DiscountKey)
references DimDiscount(DiscountKey);

select * from DimDate
select * from DimDiscount
select * from DimShippers
select * from DimEmployees
select* from DimProduct
select * from Orders_Fact
select * from Inventory_Fact
--------------------------------------------------------------------2nd Fact Query-----------------------------------------------------------------
select a.DiscountKey, b.ProductKey, d.EmployeeKey, e.ShipperKey, a.OrderID, (DiscountPercent * a.UnitPrice) as DiscountPrice, (a.UnitPrice - (DiscountPercent * a.UnitPrice)) as DiscountedUnitPrice, b.ProductName,
(d.FirstName  +  d.LastName) as EmployeeName, e.CompanyName, f.DateKey, f.OrderDate, f.RequiredDate, f.ShippedDate from [NORTHWIND].dbo.Orders c, [DimDiscount] a, [DimProduct] b, [DimEmployees] d, [DimShippers] e, [DimDate] f
where a.UnitPrice=b.UnitPrice and a.OrderID=c.OrderID and c.EmployeeID=d.EmployeeID and e.ShipperID=c.ShipVia and a.DiscountKey=f.DateKey order by d.EmployeeKey


select a.CustomerID, c.OrderID, b.CompanyName, b.ContactName, b.ContactTitle, b.Address, b.City, b.Region, b.PostalCode,b.Country, b.Phone, b.Fax from [Orders] a, [Customers] b, [Order Details] c where a.OrderID=c.OrderID and a.CustomerID=b.CustomerID order by c.OrderID
---------------------------------------------------------------------------Extra Queries---------------------------------------------------------------------

select a.OrderID, a.CustomerID, a.EmployeeID, a.ShipVia, b.UnitPrice, (Discount*UnitPrice) as DiscountPrice, (UnitPrice-(Discount*UnitPrice)) as DiscountedUnitPrice   from [Orders] a, [Order Details] b where a.OrderID=b.OrderID; 
 select c.ShipVia, d.CompanyName from [Orders] c, [Shippers] d where d.ShipperID=c.ShipVia


  select a.OrderDate, a.RequiredDate, a.ShippedDate, b.BirthDate, b.HireDate from [Orders] a, [Employees] b where a.EmployeeID=b.EmployeeID order by OrderID

  select (FirstName  +  LastName) as EmployeeName from Employees

  select a.CustomerID, b.OrderID, c.CompanyName, c.ContactName, c.ContactTitle, c.Address, c.City, c.Region, c.PostalCode, c.Country, c.Phone, c.Fax from [Orders] a, [Order Details] b, [Customers] c where a.OrderID=b.OrderID order by OrderID

  select a.EmployeeID, b.OrderID, c.LastName, c.FirstName, c.Title, c.TitleOfCourtesy, c.Address, c.City, c.Region, c.PostalCode, c.Country, c.HomePhone, c.Extension, c.Photo, c.Notes, c.ReportsTo, c.PhotoPath from [Orders] a, [Order Details] b, [Employees] c where a.OrderID=b.OrderID order by OrderID

  select a.ShipVia, a.Freight, a.ShipName, a.ShipAddress, a.ShipCity, a.ShipRegion, a.ShipPostalCode, a.ShipCountry, b.OrderID, c.CompanyName, c.Phone from [Orders] a, [Order Details] b, [Shippers] c where a.OrderID=b.OrderID order by ShipVia
  
  select DiscountKey, (DiscountPercent*UnitPrice) as DiscountPrice, (UnitPrice-(DiscountPercent*UnitPrice)) as DiscountedUnitPrice from DimDiscount order by OrderID
  ------------------------------------------------------------------------------------------------
  --------------------------------------------------------
  select a.OrderID, b.UnitPrice, b.Discount from [Orders] a, [Order Details] b where a.OrderID=b.OrderID
  
  select c.CustomerKey, c.CustomerID, d.CalenderKey, d.OrderDate, d.RequiredDate from [DimCustomer] c, [DimCalender] d, [NORTHWIND].dbo.Orders e where e.CustomerID=c.CustomerID

  select a.Ship

  select a.EmployeeID, b.OrderID from [Employees] a, [Orders] b

  select a.EmployeeKey, a.EmployeeID, (FirstName + LastName) as EmployeeName, b.CustomerKey, b.CustomerID, c.ShipperKey, c.CompanyName, d.CalenderKey, d.OrderDate, d.RequiredDate, d.ShippedDate, e.DiscountKey, (DiscountPercent*UnitPrice) as DiscountPrice, (UnitPrice-(DiscountPercent*UnitPrice)) as DiscountedUnitPrice 
  from [DimEmployees] a, [DimCustomer] b, [DimShippers] c, [DimCalender] d, [DimDiscount] e


Create table DimCustomer(
CustomerKey int identity(1,1) not null primary key,
CustomerID nchar(5) not null,
OrderID int not null,
CompanyName nvarchar(40) not null,
ContactName nvarchar(30) null,
ContactTitle nvarchar(30) null,
Address nvarchar(60) null,
City nvarchar(15) null,
Region nvarchar(15) null,
PostalCode nvarchar(10) null,
Country nvarchar(15) null,
Phone nvarchar(24) null,
Fax nvarchar(24) null
);
CustomerKey int not null,
	CustomerID nchar(5) not null,
alter table Orders_Fact add constraint FK_Orders_Fact_DimCustomer foreign key(CustomerKey)
references DimCustomer(CustomerKey);
select * from DimCustomer

ALTER TABLE Inventory_Fact DROP column Description
ALTER TABLE Inventory_Fact DROP column Description
 
 select a.OrderDate, a.ShippedDate, a.RequiredDate from [Orders] a, [Order Details] b where a.OrderID=b.OrderID
  
  select a.EmployeeID,  a.HireDate, (FirstName + LastName) as EmployeeName, b.CompanyName, b.ShipperID, c.OrderDate, c.RequiredDate, c.ShippedDate, d.OrderID, (Discount*UnitPrice) as DiscountPrice, (UnitPrice-(Discount*UnitPrice)) as DiscountedUnitPrice, e.CustomerID from [Employees] a, [Shippers] b, [Orders] c, [Order Details] d, [Customers] e where c.OrderID=d.OrderID
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------