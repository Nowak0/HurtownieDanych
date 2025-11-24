USE Szkoła;
GO

IF OBJECT_ID('DimUczen','U') IS NOT NULL DROP TABLE DimUczen;
CREATE TABLE DimUczen (
    ID_Ucznia int IDENTITY(1,1) PRIMARY KEY,
    Pesel char(11) NOT NULL,
    ImieNazwisko varchar(50) NOT NULL,
    DataUrodzenia date NULL,
    Wiek int NULL,
    IsCurrent bit NOT NULL DEFAULT 1
);

CREATE INDEX IX_DimUczen_Pesel_IsCurrent ON DimUczen(Pesel, IsCurrent);

DECLARE @EntryDate datetime = GETDATE();

IF OBJECT_ID('vETLDimUczenData','V') IS NOT NULL DROP VIEW vETLDimUczenData;
GO
CREATE VIEW vETLDimUczenData AS
SELECT
    Pesel,
    ImieNazwisko = CAST(Imie + ' ' + Nazwisko AS varchar(50)),
    DataUrodzenia = dbo.fn_peel_to_date(Pesel),
    Wiek = CASE WHEN dbo.fn_peel_to_date(Pesel) IS NOT NULL
               THEN DATEDIFF(year, dbo.fn_peel_to_date(Pesel), @EntryDate)
               ELSE NULL END,
    1 AS IsCurrent
FROM stg_uczen;
GO

MERGE DimUczen AS target
USING vETLDimUczenData AS source
ON target.Pesel = source.Pesel AND target.IsCurrent = 1
WHEN MATCHED AND (
        target.ImieNazwisko <> source.ImieNazwisko OR
        target.DataUrodzenia <> source.DataUrodzenia OR
        target.Wiek <> source.Wiek
    )
    THEN UPDATE SET target.IsCurrent = 0
WHEN NOT MATCHED BY TARGET
    THEN INSERT (Pesel, ImieNazwisko, DataUrodzenia, Wiek, IsCurrent)
         VALUES (source.Pesel, source.ImieNazwisko, source.DataUrodzenia, source.Wiek, 1);
GO