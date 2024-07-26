-- Query Store
-- Erstellt w�hrend des Normalbetriebs Statistiken zu Abfragen
-- Speichern Abfragen, Zeiten, Verbrauch

-- Rechtsklick auf DB -> Eigenschaften -> Abfragespeicher

SELECT * FROM Northwind.dbo.Orders 
INNER JOIN M005_Index
ON M005_Index.CustomerID = Orders.CustomerID

/*
	Der Abfragespeicher hat 3 Speicher:

	- Der Planspeicher, der die Informationen zum Ausf�hrungsplan speichert
	- Einen Speicher f�r die Laufstatistik, der speichert Informationen bzgl. Ausf�hrungsstatistiken
	- Einen Speicher f�r Wartestatistik, der speicher Informationen bzgl. Wartestatistik
*/

/*
	Use Case:

	- �berwachen des Verlaufs von Abfragepl�nen f�r eine bestimmte Abfrage

	- Analysieren (CPU, Arbeitsspeicher)

*/

/*
	Query Store aktivieren:

	ALTER DATABASE [Datenbankname]
	SET QUERY_STORE = ON (OPERATION_MODE = READ_WRITE)
*/