-- Query Store
-- Erstellt während des Normalbetriebs Statistiken zu Abfragen
-- Speichern Abfragen, Zeiten, Verbrauch

-- Rechtsklick auf DB -> Eigenschaften -> Abfragespeicher

SELECT * FROM Northwind.dbo.Orders 
INNER JOIN M005_Index
ON M005_Index.CustomerID = Orders.CustomerID

/*
	Der Abfragespeicher hat 3 Speicher:

	- Der Planspeicher, der die Informationen zum Ausführungsplan speichert
	- Einen Speicher für die Laufstatistik, der speichert Informationen bzgl. Ausführungsstatistiken
	- Einen Speicher für Wartestatistik, der speicher Informationen bzgl. Wartestatistik
*/

/*
	Use Case:

	- Überwachen des Verlaufs von Abfrageplänen für eine bestimmte Abfrage

	- Analysieren (CPU, Arbeitsspeicher)

*/

/*
	Query Store aktivieren:

	ALTER DATABASE [Datenbankname]
	SET QUERY_STORE = ON (OPERATION_MODE = READ_WRITE)
*/