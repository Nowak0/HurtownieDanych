use Szkoła
go

create table Uczen (
    ID_Ucznia int identity(1,1) primary key,
    Pesel VARCHAR(11) not null unique,
    ImieNazwisko varchar(50) not null,
    Wiek int not null,
    IsCurrent int not null
);

create table Przedmiot (
    ID_Przedmiotu int identity(1,1) primary key,
    Nazwa varchar(50) not null
);

create table Klasa (
    ID_Klasy int identity(1,1) primary key,
    Nazwa char(2) not null,
    Wielkosc_klasy varchar(7) not null
);

create table Data (
    ID_Daty int identity(1,1) primary key,
    Data date not null,
    Rok int not null,
    Miesiac int not null,
    Dzien int not null
);

create table Junk (
    ID_Junk int identity(1,1) primary key,
    Ocena int not null,
    Frekwencja varchar(6) not null,
    Czy_zdany_przedmiot int not null,
    Czy_zdana_matura int null
);

create table Koniec_roku (
    ID_Ucznia int not null,
    ID_Przedmiotu int not null,
    ID_Klasy int not null,
    ID_Roku_szkolnego int not null,
    ID_Daty_matury int null,
    ID_Junk int not null,
    Ocena_z_przedmiotu int not null,
    Frekwencja int not null,
    Wynik_z_matury int null,
    constraint FK_Koniec_roku_uczen foreign key (ID_Ucznia) references Uczen(ID_Ucznia),
    constraint FK_Koniec_roku_przedmiot foreign key (ID_Przedmiotu) references Przedmiot(ID_Przedmiotu),
    constraint FK_Koniec_roku_klasa foreign key (ID_Klasy) references Klasa(ID_Klasy),
    constraint FK_Koniec_roku_rok_szkolny foreign key (ID_Roku_szkolnego) references Data(ID_Daty),
    constraint FK_Koniec_roku_data_matury foreign key (ID_Daty_matury) references Data(ID_Daty),
    constraint FK_Koniec_roku_junk foreign key (ID_Junk) references Junk(ID_Junk),
    constraint PK_Koniec_roku primary key (ID_Ucznia, ID_Przedmiotu, ID_Roku_szkolnego, ID_Klasy)
);

go