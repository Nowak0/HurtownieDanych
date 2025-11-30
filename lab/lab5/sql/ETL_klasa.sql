USE Szkola;
GO

WITH SourceData AS (
    SELECT 
        k.Nazwa_klasy AS Nazwa_klasy,
        COUNT(u.Pesel) AS Liczba_uczniow,
        CASE 
            WHEN COUNT(u.Pesel) < 10 THEN 'mała'
            WHEN COUNT(u.Pesel) BETWEEN 10 AND 20 THEN 'średnia'
            ELSE 'duża'
        END AS Wielkosc_klasy,

        k.Rok_szkolny AS StartDate,
        DATEFROMPARTS(YEAR(k.Rok_szkolny), 6, 30) AS EndDate
    FROM stg_uczen_w_klasie uw
    JOIN stg_uczen u ON uw.Pesel = u.Pesel
    JOIN stg_klasa k ON uw.Nazwa_klasy = k.Nazwa_klasy
    GROUP BY 
        k.Nazwa_klasy,
        k.Rok_szkolny
)

UPDATE d
SET 
    d.EndDate = s.EndDate
FROM DimKlasa d
JOIN SourceData s 
    ON d.Nazwa = s.Nazwa_klasy
WHERE d.Wielkosc_klasy <> s.Wielkosc_klasy;
AND d.EndDate IS NULL;
GO


INSERT INTO DimKlasa (Nazwa, Wielkosc_klasy, StartDate, EndDate, IsCurrent)
SELECT
    s.Nazwa_klasy,
    s.Wielkosc_klasy,
    s.StartDate,
    NULL
FROM SourceData s
LEFT JOIN DimKlasa d
    ON d.Nazwa = s.Nazwa_klasy AND d.EndDate IS NULL
WHERE d.Nazwa IS NULL
   OR d.Wielkosc_klasy <> s.Wielkosc_klasy;
GO