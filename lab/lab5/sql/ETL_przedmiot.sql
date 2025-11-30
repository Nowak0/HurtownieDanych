USE Szkola;
GO

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