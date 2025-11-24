USE Szkoła;
GO


IF OBJECT_ID('DimUczen','U') IS NOT NULL DROP TABLE DimUczen;
GO

CREATE TABLE DimUczen (
    ID_Ucznia       INT IDENTITY(1,1) PRIMARY KEY,
    Pesel           CHAR(11) NOT NULL,
    ImieNazwisko    VARCHAR(50) NOT NULL,
    DataUrodzenia   DATE NULL,
    Wiek            INT NULL,

    StartDate       DATETIME NOT NULL DEFAULT (GETDATE()),
    EndDate         DATETIME NULL,
    IsCurrent       BIT NOT NULL DEFAULT 1
);

CREATE INDEX IX_DimUczen_Pesel_IsCurrent 
    ON DimUczen(Pesel, IsCurrent);
GO


IF OBJECT_ID('vETLDimUczenData','V') IS NOT NULL DROP VIEW vETLDimUczenData;
GO

CREATE VIEW vETLDimUczenData AS
SELECT
    Pesel,
    ImieNazwisko = CAST(Imie + ' ' + Nazwisko AS VARCHAR(50)),
    DataUrodzenia = dbo.fn_peel_to_date(Pesel),
    Wiek = CASE 
            WHEN dbo.fn_peel_to_date(Pesel) IS NOT NULL THEN 
                DATEDIFF(YEAR, dbo.fn_peel_to_date(Pesel), GETDATE())
           ELSE NULL END
FROM stg_uczen;
GO

UPDATE d
SET 
    d.IsCurrent = 0,
    d.EndDate = GETDATE()
FROM DimUczen d
JOIN vETLDimUczenData s 
    ON d.Pesel = s.Pesel
WHERE d.IsCurrent = 1
  AND (
        d.ImieNazwisko   <> s.ImieNazwisko OR
        d.DataUrodzenia  <> s.DataUrodzenia OR
        d.Wiek           <> s.Wiek
      );
GO

INSERT INTO DimUczen (Pesel, ImieNazwisko, DataUrodzenia, Wiek, StartDate, EndDate, IsCurrent)
SELECT 
    s.Pesel, 
    s.ImieNazwisko, 
    s.DataUrodzenia, 
    s.Wiek,
    GETDATE(), 
    NULL,
    1
FROM vETLDimUczenData s
JOIN DimUczen d
    ON d.Pesel = s.Pesel
   AND d.IsCurrent = 0
   AND d.EndDate = (SELECT MAX(EndDate) FROM DimUczen WHERE Pesel = d.Pesel);
GO

INSERT INTO DimUczen (Pesel, ImieNazwisko, DataUrodzenia, Wiek, StartDate, EndDate, IsCurrent)
SELECT
    s.Pesel,
    s.ImieNazwisko,
    s.DataUrodzenia,
    s.Wiek,
    GETDATE(),
    NULL,
    1
FROM vETLDimUczenData s
LEFT JOIN DimUczen d ON d.Pesel = s.Pesel
WHERE d.Pesel IS NULL;
GO