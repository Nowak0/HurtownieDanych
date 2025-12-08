USE Szkola;
GO

SET NOCOUNT ON;

IF OBJECT_ID('stg_uczen','U') IS NOT NULL DROP TABLE stg_uczen;
CREATE TABLE stg_uczen (
    Pesel varchar(11),
    Imie varchar(20),
    Nazwisko varchar(30)
);

IF OBJECT_ID('stg_klasa','U') IS NOT NULL DROP TABLE stg_klasa;
CREATE TABLE stg_klasa (
    Nazwa_klasy varchar(10),
    Rok_szkolny date not null
);

IF OBJECT_ID('stg_przedmiot','U') IS NOT NULL DROP TABLE stg_przedmiot;
CREATE TABLE stg_przedmiot (
    ID_Przedmiotu int,
    Nazwa varchar(30)
);

IF OBJECT_ID('stg_uczen_w_klasie','U') IS NOT NULL DROP TABLE stg_uczen_w_klasie;
CREATE TABLE stg_uczen_w_klasie (
    ID_Ucznia_w_klasie int not null,
    Pesel varchar(11),
    Nazwa_klasy varchar(10)
);

IF OBJECT_ID('stg_koniec_roku','U') IS NOT NULL DROP TABLE stg_koniec_roku;
CREATE TABLE stg_koniec_roku (
    ID_Ucznia_w_klasie int not null,
    ID_Przedmiotu int,
    Ocena int NOT NULL,
    Frekwencja int NOT NULL
);

IF OBJECT_ID('stg_wyniki','U') IS NOT NULL DROP TABLE stg_wyniki;
CREATE TABLE stg_wyniki (
    Pesel varchar(11),
    Przedmiot varchar(30),
    Wynik int NOT NULL,
    Data_matury date NOT NULL
);
