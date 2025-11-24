USE Szkoła;
GO

IF OBJECT_ID('DimPrzedmiot','U') IS NOT NULL DROP TABLE DimPrzedmiot;
CREATE TABLE DimPrzedmiot (
    ID_Przedmiotu int IDENTITY(1,1) PRIMARY KEY,
    SourceSubjectID int NULL,
    Nazwa varchar(300) NOT NULL,
    UNIQUE (SourceSubjectID, Nazwa)
);

MERGE DimPrzedmiot AS target
USING (
    SELECT DISTINCT
        ID_Przedmiotu AS SourceSubjectID,
        Nazwa
    FROM stg_przedmiot
) AS source
ON target.SourceSubjectID = source.SourceSubjectID
WHEN NOT MATCHED THEN
    INSERT (SourceSubjectID, Nazwa)
    VALUES (source.SourceSubjectID, source.Nazwa);
GO