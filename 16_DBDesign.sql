/*

	Seite: 
	8192B = 8kB Größe
	tatsächlichen Daten =  8060B
	Management Studio Daten = 132B 

	Seiten werden immer 1zu1 gelesen

	MAX. 700 DS pro Seite
	Ziel: Datensätze müssen komplett auf die Seite passen
	Wir wollen das kein Leerer Raum existiert, sollte aber minimiert werden

*/

-- dbcc: Database Control Commands
-- showcontig: Zeigt Seiteninformationen über ein Datenbankobjekt
dbcc showcontig('Orders')

CREATE DATABASE Demo3

USE Demo3

-- Ineffiziente Tabelle
CREATE TABLE M001_Test1
(
	id int identity,
	test char(4100)
)

INSERT INTO M001_Test1
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test1') -- Seiten: 20000

CREATE TABLE M001_Test2
(
	id int identity,
	test varchar(4100)
)
INSERT INTO M001_Test2 -- Seiten: 52
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test2')
----------------------------------------------

CREATE TABLE M001_Test3
(
	id int identity,
	test VARCHAR(Max)
)

INSERT INTO M001_Test3
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test3') -- Seiten: 52; Seitendichte: 95,01%
------------------------------------------------
CREATE TABLE M001_Test4
(
	id int identity,
	test nvarchar(max)
)

INSERT INTO M001_Test4
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test4') -- 60 Seiten: Seitendichte von 94,70%


CREATE TABLE M001_Test5
(
	id int identity,
	test nchar(4000)
)

INSERT INTO M001_Test5
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test5') 

-- Übung: 
-- probiert mit nchar(2000)
-- char(3000)

CREATE TABLE M001_Test6
(
	id int identity,
	test nchar(2000)
)

INSERT INTO M001_Test6
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test6') -- Seiten: 10000; Seitendichte: 99,14


----------------------------------

CREATE TABLE M001_Test7
(
	id int identity,
	test char(2000)
)

INSERT INTO M001_Test7
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test7') -- Seiten: 6672; Seitendichte: 74,53%

CREATE TABLE M001_Test8
(
	id int identity,
	test char(3000)
)

INSERT INTO M001_Test8
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test8')  -- Seiten: 10004; Seitendichte: 74,40%

-- Seitendichten Schnitt:
/*
	ab 70% OK
	ab 80% Gut
	ab 90% Sehr gut

	nvarchar: 2B pro Zeichen; varchar 1B pro Zeichen
	Ziel: Weniger Seiten -> weniger Daten laden -> bessere Performance
*/

CREATE TABLE M001_TestFloat
(
	id int identity, -- 4B
	zahl float -- 8B
)

INSERT INTO M001_TestFloat
VALUES (2.2)
GO 20000

dbcc showcontig('M001_TestFloat') -- Seiten: 55; Seitendichte: 94,32%


CREATE TABLE M001_TestDecimal
(
	id int identity, --4B
	zahl decimal(2,1) --2B
)

INSERT INTO M001_TestDecimal
VALUES (2.2)
GO 20000

dbcc showcontig('M001_TestDecimal') -- Seiten: 47; Seitendichte: 94,61%

-- Statistiken für Zeit und Lesevorgänge aktivieren/deaktivieren
SET STATISTICS time, io OFF

SELECT * FROM M001_Test1
SELECT * FROM INFORMATION_SCHEMA.TABLES
SELECT * FROM INFORMATION_SCHEMA.COLUMNS -- Alle Spalten der Datenbank anzeigen -> Datentypen

-- Schnellere Variante
BEGIN TRANSACTION
DECLARE @i int = 0
WHILE @i < 20000
BEGIN
	INSERT INTO M001_TestDecimal VALUES(2.2)
	SET @i += 1
End
commit

SELECT OBJECT_NAME(OBJECT_ID), * FROM 
sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED')