use Szko³a
SELECT * FROM UCZEN

INSERT INTO UCZEN (Pesel, Imiê, Nazwisko)
VALUES
    ('01235792857', 'Jan', 'Pierwszy'),
    ('01227501297', 'Anna', 'Druga'),
    ('01240295185', 'Piotr', 'Trzeci');

INSERT INTO UCZEN_W_KLASIE (ID_Ucznia_w_klasie, Pesel, IDKlasy, Rok_szkolny)
VALUES 
	((SELECT MAX(ID_Ucznia_w_klasie) FROM UCZEN_W_KLASIE) + 1 ,'01235792857', '1A', '24/25'),
	((SELECT MAX(ID_Ucznia_w_klasie) FROM UCZEN_W_KLASIE) + 2 ,'01227501297' , '2B', '24/25'),
	((SELECT MAX(ID_Ucznia_w_klasie) FROM UCZEN_W_KLASIE) + 3 ,'01240295185' , '3B', '24/25');

INSERT INTO KONIEC_ROKU (ID_Ucznia_w_klasie, IDPrzedmiotu, Ocena, Frekwencja)
VALUES 
    ((SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '01235792857' AND IDKlasy = '1A' AND Rok_szkolny = '24/25'), 1,  5, 95),
	((SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '01235792857' AND IDKlasy = '1A' AND Rok_szkolny = '24/25'), 2,  4, 60),
	((SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '01235792857' AND IDKlasy = '1A' AND Rok_szkolny = '24/25'), 3,  3, 86),

	((SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '01227501297' AND IDKlasy = '2B' AND Rok_szkolny = '24/25'), 1,  3, 70),
	((SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '01227501297' AND IDKlasy = '2B' AND Rok_szkolny = '24/25'), 2,  3, 61),
	((SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '01227501297' AND IDKlasy = '2B' AND Rok_szkolny = '24/25'), 3,  2, 92),

	((SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '01240295185' AND IDKlasy = '3B' AND Rok_szkolny = '24/25'), 1,  4, 86),
	((SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '01240295185' AND IDKlasy = '3B' AND Rok_szkolny = '24/25'), 2,  5, 68),
	((SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '01240295185' AND IDKlasy = '3B' AND Rok_szkolny = '24/25'), 3,  3, 63);

UPDATE UCZEN SET Nazwisko = 'Skarpetka' WHERE Pesel = '01270719339';

UPDATE UCZEN SET Nazwisko = 'Komuda' WHERE Pesel = '10091332023';

SELECT * FROM UCZEN

SELECT * FROM UCZEN_W_KLASIE

INSERT INTO KLASA (IDKlasy, Rok_szkolny)
VALUES ('4C', '25/26');

INSERT INTO KLASA (IDKlasy, Rok_szkolny)
VALUES ('2C', '25/26');

UPDATE UCZEN_W_KLASIE
SET IDKlasy = '4C', Rok_szkolny = '25/26'
WHERE Pesel = '20052507089' AND Rok_szkolny = '24/25';

UPDATE UCZEN_W_KLASIE
SET IDKlasy = '2C', Rok_szkolny = '25/26'
WHERE Pesel = '84051260662' AND Rok_szkolny = '24/25';

SELECT * FROM KONIEC_ROKU

UPDATE KONIEC_ROKU
SET Ocena = 5
WHERE ID_Ucznia_w_klasie = (SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '26061507588' AND IDKlasy = '2B' AND Rok_szkolny = '24/25')
AND IDPrzedmiotu = 1;

UPDATE KONIEC_ROKU
SET Ocena = 2
WHERE ID_Ucznia_w_klasie = (SELECT ID_Ucznia_w_klasie FROM UCZEN_W_KLASIE WHERE Pesel = '67020766046' AND IDKlasy = '2A' AND Rok_szkolny = '24/25')
AND IDPrzedmiotu = 2;

SELECT * FROM UCZEN_W_KLASIE

SELECT * FROM KONIEC_ROKU