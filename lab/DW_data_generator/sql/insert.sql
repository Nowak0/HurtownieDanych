use SzkolaHD;

bulk insert Uczen
from ''
with (
    fieldterminator = ',',
    rowterminator = '\n',
    firstrow = 2
);

bulk insert Przedmiot
from ''
with (
    fieldterminator = ',',
    rowterminator = '\n',
    firstrow = 2
);

bulk insert Klasa
from ''
with (
    fieldterminator = ',',
    rowterminator = '\n',
    firstrow = 2
);

bulk insert Data
from ''
with (
    fieldterminator = ',',
    rowterminator = '\n',
    firstrow = 2
);

bulk insert Junk
from ''
with (
    fieldterminator = ',',
    rowterminator = '\n',
    firstrow = 2
);

bulk insert Koniec_roku
from ''
with (
    fieldterminator = ',',
    rowterminator = '\n',
    firstrow = 2
);

go