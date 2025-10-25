
USE Szko³a;

CREATE TABLE UCZEN (
    Pesel VARCHAR(11) PRIMARY KEY,
    Imiê VARCHAR(20) NOT NULL,
    Nazwisko VARCHAR(30) NOT NULL
);

CREATE TABLE PRZEDMIOT (
    IDPrzedmiotu INT PRIMARY KEY,
    Nazwa VARCHAR(30) NOT NULL
);

CREATE TABLE KLASA (
    IDKlasy VARCHAR(2),
    Rok_szkolny VARCHAR(5),
    PRIMARY KEY (IDKlasy, Rok_szkolny)
);
CREATE TABLE UCZEN_W_KLASIE (
    ID_Ucznia_w_klasie INT PRIMARY KEY,
    Pesel VARCHAR(11),
    IDKlasy VARCHAR(2),
	Rok_szkolny VARCHAR(5),
    FOREIGN KEY (Pesel) REFERENCES UCZEN(Pesel),
    FOREIGN KEY (IDKlasy, Rok_szkolny) REFERENCES KLASA(IDKlasy, Rok_szkolny)
);


CREATE TABLE KONIEC_ROKU (
    ID_Ucznia_w_klasie INT,
    IDPrzedmiotu INT,
    Ocena INT NOT NULL,
    Frekwencja INT NOT NULL,
    PRIMARY KEY (ID_Ucznia_w_klasie, IDPrzedmiotu),
    FOREIGN KEY (ID_Ucznia_w_klasie) REFERENCES UCZEN_W_KLASIE(ID_Ucznia_w_klasie),
    FOREIGN KEY (IDPrzedmiotu) REFERENCES PRZEDMIOT(IDPrzedmiotu)
);
