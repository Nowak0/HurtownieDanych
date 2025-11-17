use SzkolaHD;

bulk insert Uczen
from 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\projekt\csv\Uczen.csv'
with (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '0x0A' 
);

bulk insert Przedmiot
from 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\projekt\csv\Przedmiot.csv'
with (
    fieldterminator = ',',
    rowterminator = '0x0A',
    firstrow = 2
);

bulk insert Klasa
from 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\projekt\csv\Klasa.csv'
with (
    fieldterminator = ',',
    rowterminator = '0x0A',
    firstrow = 2
);

bulk insert Data
from 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\projekt\csv\Data_matury.csv'
with (
    fieldterminator = ',',
    rowterminator = '0x0A',
    firstrow = 2
);

bulk insert Junk
from 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\projekt\csv\Junk.csv'
with (
    fieldterminator = ',',
    rowterminator = '0x0A',
    firstrow = 2
);

bulk insert Koniec_roku
from 'C:\Users\piotr\OneDrive\Pulpit\Studia\SEMESTR 5\HURTOWNIE DANYCH\projekt\csv\Koniec_roku.csv'
with (
    fieldterminator = ',',
    rowterminator = '0x0A',
    firstrow = 2
);

go