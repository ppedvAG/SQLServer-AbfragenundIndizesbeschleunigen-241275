USE Demo3

-- Daten verkleinern
-- Weniger Daten werden geladen, beim dekomprimieren wird CPU Leistung verwendet

USE Northwind;
SELECT  Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate, Orders.Freight, Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.Address, Customers.City, 
        Customers.Region, Customers.PostalCode, Customers.Country, Customers.Phone, Orders.OrderID, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title, [Order Details].UnitPrice, 
        [Order Details].Quantity, [Order Details].Discount, Products.ProductID, Products.ProductName, Products.UnitsInStock
INTO Demo3.dbo.M004_Kompression
FROM    [Order Details] INNER JOIN
        Products ON Products.ProductID = [Order Details].ProductID INNER JOIN
        Orders ON [Order Details].OrderID = Orders.OrderID INNER JOIN
        Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
        Customers ON Orders.CustomerID = Customers.CustomerID

SELECT * FROM M004_Kompression

INSERT INTO M004_Kompression
SELECT * FROM M004_Kompression
GO 8

SET STATISTICS time, io on

-- Ohne Compression
-- Logische Lesevorgänge: 28224
-- CPU-Zeit = 62ms
SELECT * FROM M004_Kompression

-- Rechtsklick auf Tabelle -> Speicher -> Manage Compression

-- Row Compression
USE [Demo3]
ALTER TABLE [dbo].[M004_Kompression] REBUILD PARTITION = ALL
WITH
(DATA_COMPRESSION = ROW
)

-- Logische Lesevorgänge: 15788
-- CPU-Zeit = 281ms
SELECT * FROM M004_Kompression

-- Page Compression
USE [Demo3]
ALTER TABLE [dbo].[M004_Kompression] REBUILD PARTITION = ALL
WITH
(DATA_COMPRESSION = PAGE
)

-- Logische Lesevorgänge = 7504
-- CPU-Zeit = 250ms
SELECT * FROM M004_Kompression

-- Alle Kompressionen anzeigen lassen
SELECT t.name as TableName, p.partition_number as PartitionsNumber, p.data_compression_desc AS Compression
FROM sys.partitions as p
JOIN sys.tables AS t ON t.object_id = p.object_id


