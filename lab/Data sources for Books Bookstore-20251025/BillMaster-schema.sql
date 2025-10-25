create database BillMaster collate Latin1_General_CI_AS;
go

use BillMaster
go

create table Book(
	ISBN varchar(17) primary key,
	Title varchar(30) not null,
	Genre varchar(15) not null
)
go

create table Author(
	IDAuthor integer primary key,
	Name1 varchar(20) not null,
	Name2 varchar(20),
	Surname varchar(30) not null
)
go

create table Authorship(
	FK_Book varchar(17) foreign key references Book,
	FK_Author integer foreign key references Author,
	primary key ("FK_Book", "FK_Author")
)
go

create table Bookstore(
	IdentificationNumber integer primary key,
	"Name" varchar(25) not null
)
go

create table Salesperson(
	PIN varchar(11) primary key,
	"Name" varchar(15) not null,
	Surname varchar(30) not null
)
go

create table Bill(
	BillNumber varchar(15) primary key,
	IssueDate datetime not null,
	PaymentDate datetime not null,
	Place varchar(50) not null,
	Payment varchar(15) not null,
	FK_Salesperson varchar(11) foreign key references Salesperson not null,
	FK_Bookstore integer foreign key references Bookstore not null
)
go

create table BookSale(
	FK_Book varchar(17) foreign key references Book,
	FK_Bill varchar(15) foreign key references Bill,
	Price decimal(6, 2) not null,
	NumberOfCopies integer not null,
	primary key ("FK_Book", "FK_Bill")
)
go

