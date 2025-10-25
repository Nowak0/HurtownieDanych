use Szko³a
GO

BULK INSERT UCZEN
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\tabelkiv3\uczniowie.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT KLASA
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\tabelkiv3\klasy.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT PRZEDMIOT
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\tabelkiv3\przedmioty.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT UCZEN_W_KLASIE
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\tabelkiv3\uczen_w_klasie.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT KONIEC_ROKU
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\tabelkiv3\koniec_roku.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'    
)