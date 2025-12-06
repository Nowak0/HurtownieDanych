USE Szkola;
GO

DECLARE @startDate DATE = '2024-09-01';
DECLARE @endDate DATE   = '2026-06-30';

;WITH Dates AS (
    SELECT @startDate AS DataDate
    UNION ALL
    SELECT DATEADD(DAY, 1, DataDate)
    FROM Dates
    WHERE DataDate < @endDate
)
INSERT INTO DimDate (DataDate, Rok, Miesiac, Dzien)
SELECT 
    d.DataDate,
    YEAR(d.DataDate) AS Rok,
    MONTH(d.DataDate) AS Miesiac,
    DAY(d.DataDate) AS Dzien
FROM Dates d
WHERE NOT EXISTS (
    SELECT 1
    FROM DimDate dd
    WHERE dd.DataDate = d.DataDate
)
OPTION (MAXRECURSION 669);
GO