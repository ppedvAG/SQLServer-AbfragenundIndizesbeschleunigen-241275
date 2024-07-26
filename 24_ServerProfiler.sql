-- Profiler
-- Live-Verfolgung was auf DB passiert
-- DB-Optimierer

-- Extras -> SQL Server Profiler

-- Einstellungen auf der ersten Seite setzen
-- Events auswählen auf dem zweiter Reiter
---- StmtStarted
---- StmtCompleted


-- Nach der Trace -> Tuning Advisor
-- Tools -> Database Engine Tuning Advisor
-- Trace File laden

-- Code generiert
CREATE NONCLUSTERED INDEX [_dta_index_M005_Index_9_1685581043__K4_17_18] ON [dbo].[M005_Index]
(
	[Freight] ASC
)
INCLUDE([LastName],[FirstName]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
