USE Szkoła;
GO

IF OBJECT_ID('DimKlasa','U') IS NOT NULL DROP TABLE DimKlasa;
CREATE TABLE DimKlasa (
    ID_Klasy int IDENTITY(1,1) PRIMARY KEY,
    Nazwa varchar(20) NOT NULL,
    Wielkosc_klasy varchar(20) NULL,
    UNIQUE (Nazwa)
);
GO

DECLARE @EntryDate datetime = GETDATE();

MERGE DimKlasa AS target
USING (
    SELECT 
        k.Nazwa_klasy AS Nazwa_klasy,
        COUNT(u.Pesel) AS Liczba_uczniow,
        CASE 
            WHEN COUNT(u.Pesel) < 10 THEN 'mała'
            WHEN COUNT(u.Pesel) BETWEEN 10 AND 20 THEN 'średnia'
            ELSE 'duża'
        END AS Wielkosc_klasy
    FROM stg_uczen_w_klasie uw
    JOIN stg_uczen u ON uw.Pesel = u.Pesel
    JOIN stg_klasa k ON uw.Nazwa_klasy = k.Nazwa_klasy
    GROUP BY k.Nazwa_klasy
) AS source
ON target.Nazwa = source.Nazwa_klasy
WHEN MATCHED THEN
    UPDATE SET target.Wielkosc_klasy = source.Wielkosc_klasy
WHEN NOT MATCHED THEN
    INSERT (Nazwa, Wielkosc_klasy)
    VALUES (source.Nazwa_klasy, source.Wielkosc_klasy);
GO