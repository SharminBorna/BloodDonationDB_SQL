
/*
SQL Project On 
Blood Donation Management System
Project Submitted By
Sharmin Sultana
Trainee Id: 1261105
Batch ID: ESAD-CS/PNTL-A/45/01
*/

--Creating Objects Script

USE master
GO

IF EXISTS(SELECT name FROM sys.sysdatabases where name='BloodDonationDB')
DROP DATABASE BloodDonationDB
GO

CREATE DATABASE BloodDonationDB
ON
(
	name = 'bloodDonation_DB_Data',
	fileName = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\bloodDonation_DB_Data.mdf',
	size = 10MB,
	maxSize = 1GB,
	fileGrowth = 10%
)
LOG ON
(
	name = 'bloodDonation_DB_Log',
	fileName = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\bloodDonation_DB_Log.ldf',
	size = 10MB,
	maxSize = 100MB,
	fileGrowth = 5MB
)
GO

USE BloodDonationDB
GO

CREATE TABLE BloodGroups
(
	bloodGroupID INT PRIMARY KEY IDENTITY,
	bloodGroupName VARCHAR (10) NOT NULL
)
GO

CREATE TABLE Gender
(
	genderID INT PRIMARY KEY IDENTITY,
	gender VARCHAR (10) NOT NULL
)
GO

CREATE TABLE Members
(
	memberID INT PRIMARY KEY IDENTITY(101,1),
	memberName VARCHAR (50) NOT NULL,
	age INT NOT NULL,
	genderID INT NOT NULL REFERENCES Gender(genderID),
	bloodGroupID INT NOT NULL REFERENCES BloodGroups(bloodGroupID),
	memberAddress VARCHAR (100) NOT NULL,
	contactNo VARCHAR (15) NOT NULL,
	email VARCHAR (70) 
)
GO

CREATE TABLE Donors
(
	donorID INT PRIMARY KEY IDENTITY,
	donorName VARCHAR (50) NOT NULL,
	age INT NOT NULL CHECK (age>=20),
	genderID INT NOT NULL REFERENCES Gender(genderID),
	bloodGroupID INT NOT NULL REFERENCES BloodGroups(bloodGroupID),
	donorAddress VARCHAR (100) NOT NULL,
	contactNo VARCHAR (15) UNIQUE NOT NULL,
	email VARCHAR (70),
	statusOfDonation INT,
	lastDonationDate DATETIME NOT NULL DEFAULT NULL
)
GO

CREATE TABLE Hospital
(
	hospitalID INT PRIMARY KEY IDENTITY (101,1),
	hospitalName VARCHAR (150) NOT NULL,
	hospitalAddress VARCHAR (100),
	contactNo VARCHAR (15)
)
GO

CREATE TABLE BloodRequest
(
	requestID INT PRIMARY KEY IDENTITY (501,1),
	requestDate DATE NOT NULL,
	bloodGroupID INT REFERENCES BloodGroups(bloodGroupID),
	quantity INT NOT NULL,
	contactNo VARCHAR (15) NOT NULL,
	locationID INT REFERENCES Hospital(hospitalID)
)
GO

CREATE TABLE Patient
(
	patientID INT PRIMARY KEY IDENTITY,
	patientName VARCHAR (50) NOT NULL,
	age INT NOT NULL,
	genderID INT NOT NULL REFERENCES Gender(genderID),
	bloodGroupID INT NOT NULL REFERENCES BloodGroups(bloodGroupID),
	contactNo VARCHAR (15) NOT NULL,
	caseDate DATETIME NOT NULL,
	reasonForBlood VARCHAR (150) NOT NULL,
	hospitalID INT NOT NULL REFERENCES Hospital(hospitalID)
)
GO

CREATE TABLE BloodStock
(
	stockID INT PRIMARY KEY NOT NULL IDENTITY,
	bloodGroupID INT REFERENCES BloodGroups(bloodGroupID),
	status VARCHAR (20) NOT NULL,
	quantity INT NULL,
	entryDate DATETIME NULL,
	useBefore DATETIME NULL
)
GO

--INSERTING DATA TO BloodGroups TABLE

INSERT INTO BloodGroups VALUES('A+')
INSERT INTO BloodGroups VALUES('A-')
INSERT INTO BloodGroups VALUES('B+')
INSERT INTO BloodGroups VALUES('B-')
INSERT INTO BloodGroups VALUES('O+')
INSERT INTO BloodGroups VALUES('O-')
INSERT INTO BloodGroups VALUES('AB+')
INSERT INTO BloodGroups VALUES('AB-')
GO


--INSERTING DATA TO Gender TABLE

INSERT INTO gender VALUES('Male')
INSERT INTO gender VALUES('Female')
GO

--RISTRICT GENDER TABLE FROM MODIFYING

CREATE TRIGGER trLockGenderTable
	ON gender
	FOR INSERT,UPDATE,DELETE
AS
	PRINT 'You can''t modify this table!'
	ROLLBACK TRANSACTION
GO


--STORED PROCEDURE FOR INSERTING DATA TO Members TABLE

CREATE PROC spInsertMembers
				@memberName VARCHAR (50),
				@age INT,
				@genderID INT,
				@bloodGroupID INT,
				@memberAddress VARCHAR (100),
				@contactNo VARCHAR (15),
				@email VARCHAR (70)
AS
BEGIN
	INSERT INTO Members VALUES
	(@memberName,@age,@genderID,@bloodGroupID,@memberAddress,@contactNo,@email)

END
GO

--STORED PROCEDURE FOR DELETING DATA TO Members TABLE

CREATE PROC spDeleteMembers
				@id int
AS
BEGIN
	DELETE Members
	WHERE memberID=@id
END
GO

--STORED PROCEDURE FOR INSERTING DATA TO Donors TABLE

CREATE PROC spInsertDonors
				@donorName VARCHAR (50),
				@age INT,
				@genderID INT,
				@bloodGroupID INT,
				@donorAddress VARCHAR (100),
				@contactNo VARCHAR (15),
				@email VARCHAR (70),
				@statusOfDonation INT,
				@lastDonationDate DATETIME
AS
BEGIN
	INSERT INTO Donors VALUES
	(@donorName,@age,@genderID,@bloodGroupID,@donorAddress,@contactNo,@email,@statusOfDonation,@lastDonationDate)
END
GO

--STORED PROCEDURE FOR DELETING DATA TO Donors TABLE

CREATE PROC spDeleteDonors
				@id int

AS
BEGIN
	DELETE Donors
	WHERE donorID=@id
END
GO

--STORED PROCEDURE FOR INSERTING DATA TO Hospital TABLE

CREATE PROC spInsertHospital
				@hospitalName VARCHAR (150),
				@hospitalAddress VARCHAR (100),
				@contactNo VARCHAR (15)
AS
BEGIN
	INSERT INTO Hospital VALUES
	(@hospitalName,@hospitalAddress,@contactNo)
END 
GO

--STORED PROCEDURE FOR DELETING DATA TO Hospital TABLE

CREATE PROC spDeleteHospital
				@id int

AS
BEGIN
	DELETE Hospital
	WHERE hospitalID=@id
END
GO

--STORED PROCEDURE FOR INSERTING DATA TO Patient TABLE

CREATE PROC spInsertPatient
				@patientName VARCHAR (30),
				@age INT,
				@genderID INT,
				@bloodGroupID INT,
				@contactNo VARCHAR (15),	
				@caseDate DATETIME,
				@reasonForBlood VARCHAR (150),
				@hospitalID INT
AS
BEGIN
	INSERT INTO Patient VALUES
	(@patientName,@age,@genderID,@bloodGroupID,@contactNo,@caseDate,@reasonForBlood,@hospitalID)
END
GO

--STORED PROCEDURE FOR DELETING DATA TO Patient TABLE

CREATE PROC spDeletePatient
					@id int
AS
BEGIN
	DELETE Patient
	WHERE patientID=@id
END
GO

--STORED PROCEDURE FOR UPDATING DATA TO BloodStock TABLE

CREATE PROC spUpdateBloodStock
				@stockID INT,
				@status VARCHAR (20),
				@quantity INT
AS
BEGIN
			UPDATE BloodStock
			SET 	status=@status,
				quantity=@quantity
			WHERE stockID=@stockID
END
GO

-----------------------------------------------------
--
--SOME DATA ENTRY
--
-----------------------------------------------------

--DATA INSERT TO Members TABLE

EXEC spInsertMembers 'Arriz',30,1,5,'Dohar','01712233771','arriz@gmail.com'
EXEC spInsertMembers 'Sadman',32,1,5,'Narangonj','01710000891','sadman@gmail.com'
EXEC spInsertMembers 'Monika',33,2,4,'Demra','01895703271','monika@gmail.com'
EXEC spInsertMembers 'Jabin',31,2,1,'Dhaka','01815933771','jabin@gmail.com'
EXEC spInsertMembers 'Jubayer',27,1,7,'Motijhil','01975231871','jubayer@gmail.com'
EXEC spInsertMembers 'Masum',45,1,3,'Mohakhali','01987053171','masum@gmail.com'
EXEC spInsertMembers 'Hasib',23,1,6,'Demra','01710875328','hasib@gmail.com'
EXEC spInsertMembers 'Borsha',20,2,8,'Dohar','0151327890','borsha@gmail.com'
EXEC spInsertMembers 'Nupur',29,2,3,'Dhanmondi','01717152477','nupur@gmail.com'
EXEC spInsertMembers 'Shorna',32,2,5,'Dohar','01713352238','shorna@gmail.com'
GO

--DATA INSERT TO Donors TABLE

EXEC spInsertDonors 'Arriz',30,1,5,'Dohar','01712233771','arriz@gmail.com',20,'2020-05-15'
EXEC spInsertDonors 'Sadman',32,1,5,'Narangonj','01710000891','sadman@gmail.com',18,'2020-08-07'
EXEC spInsertDonors 'Monika',33,2,4,'Demra','01895703271','monika@gmail.com',1,'2019-11-12'
EXEC spInsertDonors 'Jabin',31,2,1,'Dhaka','01815933771','jabin@gmail.com',2,'2019-02-13'
EXEC spInsertDonors 'Jubayer',27,1,7,'Motijhil','01975231871','jubayer@gmail.com',15,'2020-03-05'
EXEC spInsertDonors 'Masum',45,1,3,'Mohakhali','01987053171','masum@gmail.com',22,'2020-01-02'
EXEC spInsertDonors 'Hasib',23,1,6,'Demra','01710875328','hasib@gmail.com',12,'2019-07-08'
EXEC spInsertDonors 'Nupur',29,2,3,'Dhanmondi','01717152477','nupur@gmail.com',3,'2020-02-02'
EXEC spInsertDonors 'Shorna',32,2,5,'Dohar','01713352238','shorna@gmail.com',2,'2019-09-07'
EXEC spInsertDonors  'Borsha',20,2,8,'Dohar','0151327890','borsha@gmail.com',1,'2020-05-01'
GO

--DATA insert to Hospital TABLE

EXEC spInsertHospital 'Central Hospital','Dhanmondi-2','01785097512'
EXEC spInsertHospital 'Labaid Hospital','Dhanmondi-1','01987532512'
EXEC spInsertHospital 'Square Hospital','Panthopath','01717852390'
EXEC spInsertHospital 'Medicare Hospital','Gulshan Ave','01772114776'
EXEC spInsertHospital 'Ad-Din Women''s Medical College Hospital','Maghbazar',' 02-9353391'
EXEC spInsertHospital 'BRB Hospitals Limited','77/A Panthapath','01709635863'
EXEC spInsertHospital 'Popular Medical College Hospital','Eastern Point, 8-9 Shanti Nagar Rd','09613-787803'
GO

--DATA insert to BloodRequest TABLE
INSERT INTO BloodRequest VALUES ('2020-12-12',1,2,'01717196854',104)
INSERT INTO BloodRequest VALUES ('2020-12-15',2,1,'01848596247',105)
INSERT INTO BloodRequest VALUES ('2020-12-18',5,2,'01775123694',103)
INSERT INTO BloodRequest VALUES ('2020-12-12',7,2,'01578514485',101)
INSERT INTO BloodRequest VALUES ('2020-12-12',4,2,'01918569742',106)
INSERT INTO BloodRequest VALUES ('2020-12-30',5,2,'01974826994',105)
INSERT INTO BloodRequest VALUES ('2021-01-01',3,3,'01817901753',107)
INSERT INTO BloodRequest VALUES ('2021-01-01',7,1,'01817253098',102)
INSERT INTO BloodRequest VALUES ('2021-01-07',5,2,'01522898188',101)
INSERT INTO BloodRequest VALUES ('2021-01-08',5,1,'01823987389',104)
INSERT INTO BloodRequest VALUES ('2021-01-01',1,3,'01373777732',103)
INSERT INTO BloodRequest VALUES ('2020-12-19',3,2,'01973929137',102)
INSERT INTO BloodRequest VALUES ('2021-01-01',5,2,'01973983797',105)
INSERT INTO BloodRequest VALUES ('2021-01-02',6,1,'01983832838',103)
INSERT INTO BloodRequest VALUES ('2021-01-03',6,1,'01738739198',106)
INSERT INTO BloodRequest VALUES ('2020-12-30',5,3,'01989238010',105)
INSERT INTO BloodRequest VALUES ('2021-01-01',1,1,'01939797317',101)
INSERT INTO BloodRequest VALUES ('2020-12-15',3,2,'01771701911',107)
GO

--DATA insert to Patient TABLE

EXEC spInsertPatient 'Amina',25,2,5,'01758464824','2020-05-07','Delivery Surgery',105
EXEC spInsertPatient 'Amzad',45,1,2,'01987512654','2020-06-08','Open Heart Surgery',103
EXEC spInsertPatient 'Md. Nahid',35,1,4,'01854512518','2020-08-09','Bypass Surgery',101
EXEC spInsertPatient 'Md. Aymaan',32,1,5,'01918569423','2020-10-10','Heart Surgery',107
EXEC spInsertPatient 'Afsana Islam',33,2,5,'01718964235','2020-12-07','Delivery Surgery',105
EXEC spInsertPatient 'Sajjad Hossain',36,1,6,'01515289302','2020-12-10','Surgery',106
EXEC spInsertPatient 'Abu Syed',50,1,1,'01515339933','2020-12-12','Surgery',102
GO

--DATA insert to BloodStock TABLE

INSERT INTO BloodStock VALUES (1,'Available',10,'2020-12-05','2021-03-05')
INSERT INTO BloodStock VALUES (2,'Available',12,'2020-12-05','2021-03-05')
INSERT INTO BloodStock(bloodGroupID,status) VALUES (3,'Not Available')
INSERT INTO BloodStock VALUES (4,'Available',10,'2020-12-05','2021-03-05')
INSERT INTO BloodStock(bloodGroupID,status) VALUES (5,'Not Available')
INSERT INTO BloodStock VALUES (6,'Available',10,'2020-12-05','2021-03-05')
INSERT INTO BloodStock VALUES (7,'Available',10,'2020-09-30','2020-12-30')
INSERT INTO BloodStock VALUES (8,'Available',10,'2020-10-08','2021-01-08')
GO

--PREVENTING DELETATION FROM BloodStock TABLE

CREATE TRIGGER tr_RistrictDeleteFromBloodStock
ON BloodStock
FOR DELETE
AS
BEGIN
 ROLLBACK TRANSACTION
 PRINT 'Data cannot be deleted from BloodStock record'
END
GO

--Create an AFTER trigger for UPDATE,DELETE action 

CREATE TRIGGER tr_UpDelBloodGroups 
ON BloodGroups
AFTER UPDATE,DELETE
AS
BEGIN
	 PRINT 'You can''t update or delete BloodGroups table!'
	 ROLLBACK TRANSACTION
END
GO

--Create Trigger For Hospital

CREATE TRIGGER trInsert_H
ON Hospital
FOR INSERT
AS
BEGIN
	DECLARE @hospitalName VARCHAR (150),
		@hospitalAddress VARCHAR (100),
		@contactNo VARCHAR (15)
	SELECT @hospitalName=hospitalName,@hospitalAddress=hospitalAddress,@contactNo=contactNo FROM inserted
	IF @hospitalAddress=NULL
	BEGIN
		RAISERROR('hospitalAddress is not to be NULL',11,1)
		ROLLBACK TRANSACTION
	END
END
GO

INSERT INTO Hospital (hospitalName,contactNo)
VALUES ('Medinova Hospital','01713275907')
GO


--CREATING INDEX ON Hospital

CREATE NONCLUSTERED INDEX IX_Hospital_Id
ON Hospital(hospitalID)
GO

-----------------------------------------------------
--
--SOME CALCULATION
--
-----------------------------------------------------


--View for date wise blood request

CREATE VIEW vBloodRequestInfo
AS
SELECT bs.bloodGroupID,bg.bloodGroupName,br.requestDate FROM BloodRequest br
INNER JOIN BloodGroups bg ON br.bloodGroupID=bg.bloodGroupID
INNER JOIN BloodStock bs ON bg.bloodGroupID=bs.bloodGroupID
WHERE br.requestDate='2020-12-12'
GO

--Function for date wise blood request

CREATE FUNCTION fnDateWiseRequest
(
	@bloodGroupID INT
)
RETURNS TABLE
AS
RETURN
(SELECT bg.bloodGroupID, br.requestID,bg.bloodGroupName,br.requestDate,bs.quantity FROM BloodRequest br
INNER JOIN BloodGroups bg ON br.bloodGroupID=bg.bloodGroupID
INNER JOIN BloodStock bs ON bg.bloodGroupID=bs.bloodGroupID
WHERE bg.bloodGroupID=@bloodGroupID)
GO

--Function for Total Monthly Request

CREATE FUNCTION fnMonthlyTotalRequest
(
	@monthNO INT,
	@year INT
)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(requestID) FROM BloodRequest
	WHERE MONTH(requestDate)=@monthNO AND YEAR(requestDate)=@year)
END
GO

--CREATE CTE

WITH ctBloodForPatient (bloodGroupID,bloodGroupName,patientName,reasonForBlood,caseDate)
AS
(
		SELECT bg.bloodGroupID,bg.bloodGroupName,p.patientName,p.reasonForBlood,p.caseDate FROM Patient p
		INNER JOIN BloodGroups bg ON p.bloodGroupID=bg.bloodGroupID
		WHERE bg.bloodGroupName='O+'
)
SELECT * FROM ctBloodForPatient
ORDER BY patientName DESC
GO


