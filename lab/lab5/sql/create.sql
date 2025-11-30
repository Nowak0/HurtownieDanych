Use Szkola;

IF OBJECT_ID('DimDate','U') IS NOT NULL DROP TABLE DimDate;
CREATE TABLE DimDate (
    ID_Daty int IDENTITY(1,1) PRIMARY KEY,
    DataDate date NOT NULL UNIQUE,
    Rok int NOT NULL,
    Miesiac int NOT NULL,
    Dzien int NOT NULL
);
GO

IF OBJECT_ID('DimJunk','U') IS NOT NULL DROP TABLE DimJunk;
CREATE TABLE DimJunk (
    ID_Junk int IDENTITY(1,1) PRIMARY KEY,
    Ocena int NOT NULL,
    Frekwencja varchar(10) NOT NULL,
    Czy_zdany_przedmiot bit NOT NULL,
    Czy_zdana_matura bit NULL
);
GO

IF OBJECT_ID('DimKlasa','U') IS NOT NULL DROP TABLE DimKlasa;
CREATE TABLE DimKlasa (
    ID_Klasy int IDENTITY(1,1) PRIMARY KEY,
    Nazwa varchar(20) NOT NULL,
    Wielkosc_klasy varchar(20) NULL,
    StartDate date NOT NULL,
    EndDate date NULL
);
GO

IF OBJECT_ID('DimPrzedmiot','U') IS NOT NULL DROP TABLE DimPrzedmiot;
CREATE TABLE DimPrzedmiot (
    ID_Przedmiotu int IDENTITY(1,1) PRIMARY KEY,
    SourceSubjectID int NULL,
    Nazwa varchar(300) NOT NULL,
    UNIQUE (SourceSubjectID, Nazwa)
);
GO

IF OBJECT_ID('DimUczen','U') IS NOT NULL DROP TABLE DimUczen;
CREATE TABLE DimUczen (
    ID_Ucznia       INT IDENTITY(1,1) PRIMARY KEY,
    Pesel           CHAR(11) NOT NULL,
    ImieNazwisko    VARCHAR(50) NOT NULL,
    Wiek            INT NULL,

    StartDate       DATETIME NOT NULL DEFAULT (GETDATE()),
    EndDate         DATETIME NULL,
    IsCurrent       BIT NOT NULL DEFAULT 1
);
GO

IF OBJECT_ID('FactKoniecRoku','U') IS NOT NULL DROP TABLE FactKoniecRoku;
CREATE TABLE FactKoniecRoku (
    ID_Ucznia int NOT NULL,
    ID_Klasy int NOT NULL,
    ID_Przedmiotu int NOT NULL,
    ID_Roku_szkolnego int NOT NULL,
    ID_Daty_matury int NULL,
    ID_Junk int NOT NULL,
    Ocena_z_przedmiotu int NULL,
    Frekwencja int NULL,
    Wynik_z_matury int NULL,
    CONSTRAINT PK_FactKoniecRoku PRIMARY KEY (
        ID_Ucznia,
        ID_Klasy,
        ID_Przedmiotu,
        ID_Roku_szkolnego,
        ID_Junk
    )
);