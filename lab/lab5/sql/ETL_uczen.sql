USE Szkola;
GO

IF OBJECT_ID('vETLSourceUczen','V') IS NOT NULL DROP VIEW vETLSourceUczen;
GO

CREATE VIEW vETLSourceUczen AS
SELECT DISTINCT 
    u.Pesel,
    u.Imie + ' ' + u.Nazwisko AS ImieNazwisko,
    k.Rok_szkolny AS StartDate,
    DATEDIFF(YEAR, dbo.fn_peel_to_date(u.Pesel), k.Rok_szkolny) AS Wiek,
    DATEFROMPARTS(YEAR(k.Rok_szkolny), 6, 30) AS EndDate
FROM stg_uczen u
JOIN stg_uczen_w_klasie uw ON u.Pesel = uw.Pesel
JOIN stg_klasa k
    ON REPLACE(REPLACE(uw.Nazwa_klasy, CHAR(13), ''), CHAR(10), '') 
       = REPLACE(REPLACE(k.Nazwa_klasy, CHAR(13), ''), CHAR(10), '')
GO

UPDATE d
SET d.IsCurrent = 0,
    d.EndDate   = s.EndDate
FROM DimUczen d
JOIN vETLSourceUczen s
    ON d.Pesel = s.Pesel
WHERE d.IsCurrent = 1
  AND (
        d.ImieNazwisko <> s.ImieNazwisko OR
        d.Wiek <> s.Wiek OR
        d.StartDate <> s.StartDate
      );

UPDATE d
SET d.IsCurrent = 0,
    d.EndDate = DATEFROMPARTS(YEAR(d.StartDate)+1, 6, 30)
FROM DimUczen d
LEFT JOIN vETLSourceUczen s
    ON d.Pesel = s.Pesel
WHERE d.IsCurrent = 1
  AND s.Pesel IS NULL;

INSERT INTO DimUczen (Pesel, ImieNazwisko, Wiek, StartDate, EndDate, IsCurrent)
SELECT
    s.Pesel,
    s.ImieNazwisko,
    s.Wiek,
    s.StartDate,
    NULL,
    1
FROM vETLSourceUczen s
LEFT JOIN DimUczen d 
    ON d.Pesel = s.Pesel 
   AND d.IsCurrent = 1
   AND d.StartDate = s.StartDate
   AND d.ImieNazwisko = s.ImieNazwisko
   AND d.Wiek = s.Wiek
WHERE d.Pesel IS NULL;
GO