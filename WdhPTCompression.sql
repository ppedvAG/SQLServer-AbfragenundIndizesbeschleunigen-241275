/*
	Code für Tabelle: (Vorgegeben)
*/

CREATE TABLE Wiederholung
(
	datum date,
	umsatz float
)

BEGIN TRAN
DECLARE @i int = 0
WHILE @i < 100000
BEGIN
		INSERT INTO Wiederholung VALUES
		(DATEADD(DAY, FLOOR(RAND()*1095), '20210101'), RAND() * 1000)
		SET @i += 1
END
COMMIT

/* 
	Nutze nun mithilfe von der Salamitaktik bei Dateigruppen und Partitionierung um
	die Umsätze zu unterteilen
	Bereiche: 0-300, 300-600, 600-1000

	Zum Schluss komprimiere mir die Tabelle in der
	Row Ansicht:
	Page Ansicht:
	Und zeige an wieviel CPU-Leistung jeweils jede Ansicht braucht + Lesevorgänge
*/

