use Szkola
GO

BULK INSERT stg_uczen
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\t1\uczniowie.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT stg_klasa
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\t1\klasy.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT stg_przedmiot
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\t1\przedmioty.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT stg_uczen_w_klasie
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\t1\uczen_w_klasie.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'   
);

BULK INSERT stg_koniec_roku
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\t1\koniec_roku.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'    
)

BULK INSERT stg_wyniki
FROM 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\t1\wyniki.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A'    
)