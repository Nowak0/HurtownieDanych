use Egzaminy
GO

/* we do not give the primary key values because thea are automatically generated - IDENTITY phrase in CREATE statement*/
insert into dbo.Uczen("PESEL") values ('78875079183');
insert into dbo.Uczen("PESEL") values ('12365490823');

insert into dbo.Przedmiot("Nazwa") values ('Matematyka');
insert into dbo.Przedmiot("Nazwa") values ('Geografia');

/* the path must be updated, remeber FIELDTERMINATOR defines how data in dane.bulk are separated*/
BULK INSERT dbo.Ocena FROM 'D:\dane.bulk' WITH (FIELDTERMINATOR='|')