USE Szkola;
GO

DECLARE @startDate date = '2024-09-01';
DECLARE @endDate date = '2025-06-30';

;WITH Dates AS (
    SELECT @startDate AS DataDate
    UNION ALL
    SELECT DATEADD(DAY, 1, DataDate)
    FROM Dates
    WHERE DataDate < @endDate
)
INSERT INTO DimDate (DataDate, Rok, Miesiac, Dzien)
SELECT 
    DataDate,
    YEAR(DataDate) AS Rok,
    MONTH(DataDate) AS Miesiac,
    DAY(DataDate) AS Dzien
FROM Dates
OPTION (MAXRECURSION 366);
GO