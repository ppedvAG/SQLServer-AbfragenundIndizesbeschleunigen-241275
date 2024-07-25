USE Demo3

-- 0-100-200
CREATE Partition FUNCTION pf_Zahl(int) AS
RANGE LEFT FOR VALUES (100,200)

-- Für ein Partitionsschema muss immer eine Dateigruppe geben
CREATE PARTITION scheme sch_ID as 
PARTITION pf_Zahl TO (P_Test1, P_Test2, P_Test3)

-- Dateigruppe hinzufügen
ALTER DATABASE Demo2 ADD FILEGROUP [Name]

-- Datei hinzufügen
ALTER DATABASE Demo2
ADD FILE
(
	NAME = N'P_Test1',
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLKURS\MSSQL\P_Test1.ndf',
	SIZE = 8192KB,
	FILEGROWTH = 65536KB

)
TO FILEGROUP P1_Test1

CREATE TABLE M003_Test
(
	id int identity,
	zahl float
) ON sch_ID(id)

BEGIN TRANSACTION
DECLARE @i int = 0
WHILE @i < 20000
BEGIN
	INSERT INTO M003_Test VALUES (RAND() * 1000)
	SET @i += 1
END 
COMMIT

SELECT * FROM M003_Test

SELECT * FROM M003_Test
WHERE id < 50

SET STATISTICS TIME, io OFF

SELECT * FROM M003_Test
WHERE id > 500

-- Übersicht über Partition
SELECT OBJECT_NAME(OBJECT_ID), * FROM sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED')

SELECT $partition.pf_zahl(50)
SELECT $partition.pf_zahl(150)
SELECT $partition.pf_Zahl(250)

SELECT * FROM sys.filegroups
SELECT * FROM sys.allocation_units

SELECT * FROM M003_Test t
JOIN
(
	SELECT name, ips.partition_number
	FROM sys.filegroups fg --Name

	JOIN sys.allocation_units au
	ON fg.data_space_id = au.data_space_id

	JOIN sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED') ips
	ON ips.hobt_id = au.container_id

	WHERE OBJECT_NAME(ips.object_id) = 'M003_Test'
) x
ON $partition.pf_Zahl(t.id) = x.partition_number

-- Übung: Partitionierung
/*
	- Erstelle 3 Dateigruppen (Test1, Test2)
	- Erstelle 3 Dateien (jeweils Test1, Test2)
	(per Code also SQL Code)

	Erstelle eine Partitionsfunktion Namens (pf_Test)
	die von Links die Werte ausließt (0-500, 501-1000)

	Erstelle ein Partitionsschema Namens (sch_Test)
	als Partition für (pf_Test) zu (Test1, Test2)

	Lege eine Tabelle auf das Schema und befülle diese


	CREATE PARTITION FUNCTION [name](datentyp)AS
	RANGE LEFT/RIGHT FOR VALUES(Wert1, Wert2)

	CREATE PARTITION SCHEME [schemeName] AS
	PARTITION (pf_FunctionName) TO (Dateigruppe1, Dateigruppe2, usw..)


	Dateigruppe hinzufügen:
	ALTER DATABASE [Database] ADD FILEGROUP [Dateigruppe]

	Datei hinzufügen
	ALTER DATABASE [Database]
	ADD FILE
	(
		Name = ...
		FILENAME = ....
		SIZE = ...
		FILEGROWTH = ....
	) TO FILEGROUP (Dateigruppe)
*/

ALTER DATABASE Demo3 ADD FILEGROUP Uebung_1
ALTER DATABASE Demo3 ADD FILEGROUP Uebung_2
ALTER DATABASE Demo3 ADD FILEGROUP Uebung_3

CREATE PARTITION FUNCTION TestUebung(int) AS
RANGE LEFT FOR VALUES (500, 1000)

CREATE PARTITION SCHEME TestSchema AS
PARTITION TestUebung TO (Uebung_1, Uebung_2, Uebung_3)

-- Dateien hinzufügen
ALTER DATABASE Demo3
ADD FILE
(
	Name = N'Uebung_1',
	FILENAME =  N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLKURS\MSSQL\DATA\Uebung_1.ndf',
	SIZE = 8192KB,
	FILEGROWTH = 65536KB
) TO FILEGROUP Uebung_1

-- Tabelle erstellen und das Schema darauf legen
CREATE TABLE M003_TestUebung
(
	id int identity,
	zahl float
) ON TestSchema(id)

BEGIN TRANSACTION
DECLARE @k INT = 0
WHILE @k < 1500
BEGIN
	INSERT INTO M003_TestUebung VALUES (RAND() * 1000)
	SET @k += 1
END
COMMIT

SELECT * FROM M003_TestUebung Tu
JOIN 
(
	SELECT name, ips.partition_number
	FROM sys.filegroups fg -- Name

	JOIN sys.allocation_units au
	ON fg.data_space_id = au.data_space_id
	
	JOIN sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED') ips
	ON ips.hobt_id = au.container_id

	WHERE OBJECT_NAME(ips.object_id) = 'M003_TestUebung'
) x
ON $partition.TestUebung(tu.id) = x.partition_number

