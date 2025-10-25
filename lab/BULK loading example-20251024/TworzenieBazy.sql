CREATE DATABASE Egzaminy /* exams */
GO

USE Egzaminy
GO

CREATE TABLE Uczen /* student */
(
    ID_Uczen INTEGER IDENTITY(1,1) PRIMARY KEY, /* Generates primery key, from 1 with step 1 */
	PESEL varchar(11), /*PID*/
)
GO

CREATE TABLE Przedmiot /* subject */
(
	ID_Przedmiot INTEGER IDENTITY(1,1) PRIMARY KEY,
	Nazwa varchar(15), /* name */
)
GO

CREATE TABLE Ocena /* score */
(
	ID_Uczen INTEGER FOREIGN KEY REFERENCES Uczen,
	ID_Przedmiot INTEGER FOREIGN KEY REFERENCES Przedmiot,
	Ocena INTEGER, /* score */
)
GO