USE Szkoła;
GO

IF OBJECT_ID('FactKoniecRoku','U') IS NOT NULL DROP TABLE FactKoniecRoku;
CREATE TABLE FactKoniecRoku (
    FactID bigint IDENTITY(1,1) PRIMARY KEY,
    ID_Ucznia int NOT NULL,
    ID_Klasy int NOT NULL,
    ID_Przedmiotu int NOT NULL,
    ID_Roku_szkolnego int NOT NULL,
    ID_Daty_matury int NULL,
    ID_Junk int NULL,
    Ocena_z_przedmiotu int NULL,
    Frekwencja decimal(5,2) NULL,
    Wynik_z_matury decimal(9,2) NULL,
    LoadDate datetime NOT NULL DEFAULT GETDATE()
);

CREATE INDEX IX_FactKoniecRoku_Uczen ON FactKoniecRoku(ID_Ucznia);
CREATE INDEX IX_FactKoniecRoku_Klasa ON FactKoniecRoku(ID_Klasy);
CREATE INDEX IX_FactKoniecRoku_Przedmiot ON FactKoniecRoku(ID_Przedmiotu);
CREATE INDEX IX_FactKoniecRoku_RokSzkolny ON FactKoniecRoku(ID_Roku_szkolnego);
CREATE INDEX IX_FactKoniecRoku_DatyMatury ON FactKoniecRoku(ID_Daty_matury);

INSERT INTO FactKoniecRoku (
    ID_Ucznia,
    ID_Klasy,
    ID_Przedmiotu,
    ID_Roku_szkolnego,
    ID_Daty_matury,
    ID_Junk,
    Ocena_z_przedmiotu,
    Frekwencja,
    Wynik_z_matury
)
SELECT
    du.ID_Ucznia,
    dk.ID_Klasy,
    dp.ID_Przedmiotu,
    dd.ID_Daty AS ID_Roku_szkolnego,
    ddm.ID_Daty AS ID_Daty_matury,
    dj.ID_Junk,
    kr.Ocena,
    kr.Frekwencja,
    w.Wynik
FROM stg_koniec_roku kr
JOIN stg_uczen_w_klasie uw ON kr.ID_Ucznia_w_klasie = uw.ID_Ucznia_w_klasie
JOIN DimDate dd ON dd.DataDate = CAST(LEFT(uw.Rok_szkolny,4) + '-09-01' AS date)
JOIN DimUczen du ON uw.Pesel = du.Pesel AND du.IsCurrent = 1
JOIN DimKlasa dk ON uw.Nazwa_klasy = dk.Nazwa AND uw.Rok_szkolny = dk.Rok_szkolny
JOIN DimPrzedmiot dp ON kr.IDPrzedmiotu = dp.SourceSubjectID
JOIN DimJunk dj ON kr.Ocena = dj.Ocena AND kr.Frekwencja = dj.Frekwencja
LEFT JOIN stg_wyniki w ON uw.Pesel = w.Uczen_Pesel AND dp.SourceSubjectID = w.Przedmiot_zew
LEFT JOIN DimDate ddm ON w.DataMatury IS NOT NULL AND ddm.DataDate = w.DataMatury;
GO