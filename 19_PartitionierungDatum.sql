USE Demo3

-- DROP PARTITION SCHEME [Namen]
-- DROP PARTITION FUNCTION [Namen]

/*
		date = YYYY-MM-DD
		time = hh:mm:ss
		datetime = YYYY-MM-DD hh:mm:ss.mmm
		datetime2 = YYYY-MM-DD hh:mm:ss.nnnnnnn
		smalldatetime = YYYY-MM-DD hh:mm:ss

*/

CREATE PARTITION FUNCTION pf_Datum(Date) AS
RANGE LEFT FOR VALUES('20251231', '20261231', '20271231')

CREATE PARTITION SCHEME sch_Datum AS
PARTITION pf_Datum TO (Datum2024, Datum2025, Datum2026, Datum2027)

CREATE TABLE M003_Umsatz
(
	datum date,
	umsatz float
) ON sch_Datum(datum)

INSERT INTO M003_Umsatz
SELECT * FROM M002_Umsatz

SELECT MIN(Datum) as MindestGrenze, MAX(Datum) as MaximaleGrenze, partition_number FROM M003_Umsatz t
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
ON $partition.pf_Datum(t.datum) = x.partition_number
GROUP BY partition_number

/*
	Partitionierung
	1. Grenze 2024-07-25 00:00:00.000 - 2025-12-31 23:59:59.997
	2. Grenze 2026-01-01 00:00:00.000 - 2026-12-31 23:59:59.997
	3. Grenze 2027-01-01 00:00:00.000 - 2027-12-31 23:59:59.997
*/

CREATE DATABASE DEMO3

CREATE TABLE M002_Umsatz
(
	datum date,
	umsatz float
)

BEGIN TRANSACTION
DECLARE @i int = 0
WHILE @i < 20000
BEGIN
	INSERT INTO M002_Umsatz VALUES
	(DATEADD(DAY, FLOOR(RAND()*1095), '20240725'), RAND() * 1000)
	SET @i += 1
END
COMMIT

SELECT $partition.pf_Datum('20250101')

SELECT '20240725 23:59:59.997'

--------------------------------------------------
CREATE PARTITION FUNCTION pf_Datetime(datetime) AS
RANGE LEFT FOR VALUES ('20251231 23:59:59.996', '20261231 23:59:59.996', '20271231 23:59:59.996')

CREATE PARTITION SCHEME sch_Datetime AS
PARTITION pf_Datetime TO (Datetime2024, Datetime2025, Datetime2026, Datetime2027)

CREATE TABLE M003_DatetimeUmsatz
(
	datum datetime,
	umsatz float
) ON sch_Datetime(datum)

INSERT INTO M003_DatetimeUmsatz
SELECT * FROM M002_Umsatz

SELECT $partition.pf_Datetime('20251231 23:59:59.999')