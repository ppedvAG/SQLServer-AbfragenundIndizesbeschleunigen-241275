USE Demo3

/*
	Dateigruppen:
	Datenbank aufteilen in mehrere Dateien, und verschieden Datenträger
	[PRIMARY]: Hauptgruppe, existiert immer, und enthält alle Dateien (standardmäßig)

	Dateinamen:
	- Hauptfile => endung mit .mdf
	- Weitere Files => endung mit .ndf
	- Log Files => endung mit .ldf
*/

/*
	Rechtsklick auf die Datenbank -> Eigenschaften
	Dateigruppe
		- Namen vergeben & Hinzufügen
	Dateien
		- Namen vergeben & Hinzufügen, Pfad
*/

CREATE TABLE M002_FG2
(
	id int identity,
	test char(4100)
)

INSERT INTO M002_FG2
VALUES ('XYZ')
GO 20000


CREATE TABLE M002_FG_2
(
	id int,
	test char(4100)
) ON Aktiv

INSERT INTO M002_FG_2
SELECT * FROM M002_FG2

-- Salamitaktik
-- Große Tabellen in kleinere Tabellen aufteilen

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

SELECT * FROM M002_Umsatz

-- Pläne:
/*
	Execution Plan: Zeig den genauen Ablaub der Abfrage + Details an
	Aktivieren über den Button neben dem Haken "Geschätzten Ausführungsplan anzeigen"
*/
SELECT * FROM M002_Umsatz 
WHERE YEAR(datum) = 2025

DROP TABLE M002_Umsatz2025
CREATE TABLE M002_Umsatz2025
(
	datum date,
	umsatz float,
) ON Umsatz2025

INSERT INTO M002_Umsatz2025
SELECT * FROM M002_Umsatz WHERE YEAR(datum) = 2025

DROP TABLE M002_Umsatz2026
CREATE TABLE M002_Umsatz2026
(
	datum date,
	umsatz float,
)

INSERT INTO M002_Umsatz2026
SELECT * FROM M002_Umsatz WHERE YEAR(datum) = 2026

DROP TABLE M002_Umsatz2027
CREATE TABLE M002_Umsatz2027
(
	datum date,
	umsatz float,
)

INSERT INTO M002_Umsatz2027
SELECT * FROM M002_Umsatz WHERE YEAR(datum) = 2027

-- Indizierte Sicht
-- View, welche auf die nur unterliegenden Tabellen greift, welche auch benötigt werden

ALTER TABLE M002_Umsatz2025 ADD CONSTRAINT UmsatzJahr2025New CHECK (YEAR(datum) = 2025)
ALTER TABLE M002_Umsatz2026 ADD CONSTRAINT UmsatzJahr2026New CHECK (YEAR(datum) = 2026)
ALTER TABLE M002_Umsatz2027 ADD CONSTRAINT UmsatzJahr2027New CHECK (YEAR(datum) = 2027)

CREATE VIEW UmsatzGesamt
AS
SELECT * FROM M002_Umsatz2025
UNION ALL
SELECT * FROM M002_Umsatz2026
UNION ALL
SELECT * FROM M002_Umsatz2027

SELECT * FROM UmsatzGesamt
WHERE datum >= '20250101' AND datum <= '20251231'
