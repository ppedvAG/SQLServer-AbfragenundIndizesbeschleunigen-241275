SELECT * FROM M002_Umsatz

-- Index 

/*
	-- Table Scan: Durchsucht die ganze Tabelle (langsam)
	-- Index Scan: Durchsucht bestimmte Teile in der Tabelle (besser)
	-- Index Seek: Gezielt zu den Daten hin (am besten)

	Clustered Index:
	Normaler Index, der sich selbst sortiert
	bei INSERT/UDATE
	Kann nur einmal pro Tabelle existieren
	-- Kostet Performance
	Standardmäßig mit dem PK erstellt

	Non-Clustered Index:
	Standardindex
	Zwei Komponenten: Schlüsselspalte, restlichen Spalten
*/

SELECT *
INTO M005_Index
FROM M004_Kompression

USE Demo3

SET STATISTICS time, IO on

SELECT * FROM M005_Index

-- Cost: 21%; Lesevorgänge: 28247, CPU-Zeit: 111ms
SELECT * FROM M005_Index
WHERE OrderID >= 11000

-- Cost 2,17%; Lesevorgänge: 2883, CPU-Zeit: 15ms
-- Neuen Index: NCIX_OrderID
SELECT * FROM M005_Index
WHERE OrderID >= 11000

SELECT CompanyName, Country, ProductName FROM M005_Index
WHERE OrderID >= 11000

-- Neuer Index: NCIX_ProductName
-- Operatorkosten: 21%; logische Lesevorgänge 28247; CPU-Zeit: 141ms
-- mit Index:
-- Operatorkosten: 0,06%; logische Lesevorgänge von: 81; CPU-Zeit: 0ms
SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice
FROM M005_Index
WHERE ProductName = 'Chocolade'

-- gruppierter Index

-- View mit Index
-- Benötigen SCHEMABINDING
-- WITH SCHEMABINDING: Solange die View existiert, kann die Tabellenstruktur nicht verändert werden

ALTER TABLE M005_Index
ADD ID INT IDENTITY

DROP VIEW Adressen

CREATE VIEW Adressen WITH SCHEMABINDING
AS
SELECT id, CompanyName, Address, City, Region, PostalCode, Country
FROM dbo.M005_Index

-- Clustered Index Scan
-- Cost 7,6
SELECT * FROM Adressen

SELECT id, CompanyName, Address, City, Region, PostalCode, Country
FROM dbo.M005_Index

-- Clustered Index Insert
INSERT INTO M005_Index (CustomerID, OrderID, EmployeeID, ProductID,CompanyName, Address, City, Region, PostalCode, Country, LastName, FirstName, UnitPrice, Quantity, ProductName, Discount)
VALUES('PPEDV', 34567, 2, 3,'PPEDV', 'Eine Straße', 'Irgendwo', NULL, NULL, NULL, 'Test', 'Test', 250.23, 23, 'Dönerbox', 1)

-- Clustered Index löschen
DELETE FROM M005_Index
WHERE ID = 551681
	AND ProductID = 3
	AND CustomerID = 'PPEDV'

SELECT * FROM M005_Index

-- Index Seek
SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice, Freight
FROM M005_Index
WHERE Freight > 50





