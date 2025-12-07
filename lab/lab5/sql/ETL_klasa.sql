USE Szkola;
GO

IF OBJECT_ID('vETLSourceKlasa','V') IS NOT NULL DROP VIEW vETLSourceKlasa;
GO

CREATE VIEW vETLSourceKlasa AS
SELECT 
        k.Nazwa_klasy AS Nazwa_klasy,
        COUNT(u.Pesel) AS Liczba_uczniow,
        CASE 
            WHEN COUNT(u.Pesel) < 10 THEN 'mała'
            WHEN COUNT(u.Pesel) BETWEEN 10 AND 20 THEN 'średnia'
            ELSE 'duża'
        END AS Wielkosc_klasy,

        k.Rok_szkolny AS StartDate,
        DATEFROMPARTS(YEAR(k.Rok_szkolny)+1, 6, 30) AS EndDate
    FROM stg_uczen_w_klasie uw
    JOIN stg_uczen u ON uw.Pesel = u.Pesel
    JOIN stg_klasa k ON uw.Nazwa_klasy = k.Nazwa_klasy
    GROUP BY 
        k.Nazwa_klasy,
        k.Rok_szkolny;
GO 

UPDATE d
SET d.EndDate = DATEFROMPARTS(YEAR(d.StartDate)+1, 6, 30)
FROM DimKlasa d
LEFT JOIN vETLSourceKlasa s
    ON d.Nazwa = s.Nazwa_klasy
WHERE d.EndDate IS NULL
  AND s.Nazwa_klasy IS NULL;

UPDATE d
SET 
    d.EndDate = s.EndDate
FROM DimKlasa d
JOIN vETLSourceKlasa s 
    ON d.Nazwa = s.Nazwa_klasy
WHERE d.EndDate IS NULL
AND d.StartDate < s.StartDate;

INSERT INTO DimKlasa (Nazwa, Wielkosc_klasy, StartDate, EndDate)
SELECT
    s.Nazwa_klasy,
    s.Wielkosc_klasy,
    s.StartDate,
    NULL
FROM vETLSourceKlasa s
LEFT JOIN DimKlasa d
    ON d.Nazwa = s.Nazwa_klasy AND d.StartDate = s.StartDate
WHERE d.Nazwa IS NULL;
GO