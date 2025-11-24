USE Szkoła;
GO

SET NOCOUNT ON;

IF OBJECT_ID('stg_uczen','U') IS NOT NULL DROP TABLE stg_uczen;
CREATE TABLE stg_uczen (
    Pesel char(11),
    Imie nvarchar(100),
    Nazwisko nvarchar(100)
);

IF OBJECT_ID('stg_klasa','U') IS NOT NULL DROP TABLE stg_klasa;
CREATE TABLE stg_klasa (
    Nazwa_klasy char(2),
    Rok_szkolny int
);

IF OBJECT_ID('stg_przedmiot','U') IS NOT NULL DROP TABLE stg_przedmiot;
CREATE TABLE stg_przedmiot (
    IDPrzedmiotu int,
    Nazwa nvarchar(30)
);

IF OBJECT_ID('stg_uczen_w_klasie','U') IS NOT NULL DROP TABLE stg_uczen_w_klasie;
CREATE TABLE stg_uczen_w_klasie (
    ID_Ucznia_w_klasie varchar(50),
    Pesel varchar(20),
    Nazwa_klasy varchar(10),
    Rok_szkolny varchar(20)
);

IF OBJECT_ID('stg_koniec_roku','U') IS NOT NULL DROP TABLE stg_koniec_roku;
CREATE TABLE stg_koniec_roku (
    ID_Ucznia_w_klasie varchar(50),
    IDPrzedmiotu int,
    Ocena int NOT NULL,
    Frekwencja int NOT NULL
);

IF OBJECT_ID('stg_wyniki','U') IS NOT NULL DROP TABLE stg_wyniki;
CREATE TABLE stg_wyniki (
    Uczen_Pesel char(11),
    Przedmiot_zew varchar(30),
    Wynik decimal(9,2) NULL
);
