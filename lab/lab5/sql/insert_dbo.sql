use Szkoła
GO

BULK INSERT Uczen
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\tabelkiv3\uczniowie.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT Klasa
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\tabelkiv3\klasy.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT Przedmiot
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\tabelkiv3\przedmioty.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT Uczen_w_klasie
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\tabelkiv3\uczen_w_klasie.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT Koniec_roku
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\tabelkiv3\koniec_roku.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'    
)