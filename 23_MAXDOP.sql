-- MAXDOP
-- Maximum Degree of Parallelism
-- Abfrage steuern mit der Anzahl von Prozessorkerne
-- Parallelisierung passiert von alleine

-- 3 Ebenen
-- 1. Abfrage
-- 2. Datenbank
-- 3. Server

SET STATISTICS time, IO on

SELECT Freight, FirstName, LastName
FROM M005_Index
WHERE Freight > (SELECT aVG(Freight) FROM M005_Index)
-- Diese Abfrage wird parallelisiert durch diese zwei schwarzen Pfeile in dem gelben Kreis
--> Execution Plan

SELECT Freight, FirstName, LastName FROM
M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 1)


SELECT Freight, FirstName, LastName FROM
M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 2)

SELECT Freight, FirstName, LastName FROM
M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 4)

SELECT Freight, FirstName, LastName FROM
M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 8)

