USE Szkoła;
GO

IF OBJECT_ID('DimDate','U') IS NOT NULL DROP TABLE DimDate;
CREATE TABLE DimDate (
    ID_Daty int IDENTITY(1,1) PRIMARY KEY,
    DataDate date NOT NULL UNIQUE,
    Rok int NOT NULL,
    Miesiac int NOT NULL,
    Dzien int NOT NULL,
    Kwartał int NULL,
    DzienTygodnia int NULL
);