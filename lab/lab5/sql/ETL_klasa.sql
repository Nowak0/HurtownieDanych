USE Szkoła;
GO

IF OBJECT_ID('DimKlasa','U') IS NOT NULL DROP TABLE DimKlasa;
CREATE TABLE DimKlasa (
    ID_Klasy int IDENTITY(1,1) PRIMARY KEY,
    Nazwa varchar(20) NOT NULL,
    Rok_szkolny varchar(20) NULL,
    Wielkosc_klasy varchar(20) NULL,
    UNIQUE (Nazwa, Rok_szkolny)
);


DECLARE @EntryDate datetime = GETDATE();

MERGE DimKlasa AS target
USING (
    SELECT 
        Nazwa_klasy,
        Rok_szkolny,
        COUNT(u.Pesel) AS Liczba_uczniow,
        CASE 
            WHEN COUNT(u.Pesel) < 10 THEN 'mała'
            WHEN COUNT(u.Pesel) BETWEEN 10 AND 20 THEN 'średnia'
            ELSE 'duża'
        END AS Wielkosc_klasy
    FROM stg_uczen_w_klasie uw
    JOIN stg_uczen u ON uw.Pesel = u.Pesel
    GROUP BY Nazwa_klasy, Rok_szkolny
) AS source
ON target.Nazwa = source.Nazwa_klasy AND target.Rok_szkolny = source.Rok_szkolny
WHEN MATCHED THEN
    UPDATE SET target.Wielkosc_klasy = source.Wielkosc_klasy
WHEN NOT MATCHED THEN
    INSERT (Nazwa, Rok_szkolny, Wielkosc_klasy)
    VALUES (source.Nazwa_klasy, source.Rok_szkolny, source.Wielkosc_klasy);
GO