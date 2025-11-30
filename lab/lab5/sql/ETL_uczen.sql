USE Szkola;
GO


IF OBJECT_ID('vETLDimUczenData','V') IS NOT NULL DROP VIEW vETLDimUczenData;
GO

CREATE VIEW vETLDimUczenData AS
SELECT
    Pesel,
    ImieNazwisko = CAST(Imie + ' ' + Nazwisko AS VARCHAR(50)),
    Wiek = CASE 
            WHEN dbo.fn_peel_to_date(Pesel) IS NOT NULL THEN 
                DATEDIFF(YEAR, dbo.fn_peel_to_date(Pesel), GETDATE())
           ELSE NULL END
FROM stg_uczen;
GO

WITH SourceData AS (
    SELECT
        u.Pesel,
        u.Imie + ' ' + u.Nazwisko AS ImieNazwisko,
        DATEDIFF(YEAR, dbo.fn_peel_to_date(u.Pesel), GETDATE()) AS Wiek,
        k.Rok_szkolny AS StartDate,
        DATEFROMPARTS(YEAR(k.Rok_szkolny), 6, 30) AS EndDate
    FROM stg_uczen u
    JOIN stg_uczen_w_klasie uw ON u.Pesel = uw.Pesel
    JOIN stg_klasa k ON uw.Nazwa_klasy = k.Nazwa_klasy
)

UPDATE d
SET 
    d.IsCurrent = 0,
    d.EndDate = s.EndDate
FROM DimUczen d
JOIN vETLDimUczenData s 
    ON d.Pesel = s.Pesel
WHERE d.IsCurrent = 1
  AND (
        d.ImieNazwisko   <> s.ImieNazwisko OR
        d.Wiek           <> s.Wiek
      );
GO

INSERT INTO DimUczen (Pesel, ImieNazwisko, Wiek, StartDate, EndDate, IsCurrent)
SELECT
    s.Pesel,
    s.ImieNazwisko,
    s.Wiek,
    s.StartDate,
    NULL,
    1
FROM vETLDimUczenData s
LEFT JOIN DimUczen d ON d.Pesel = s.Pesel
WHERE d.Pesel IS NULL;
GO