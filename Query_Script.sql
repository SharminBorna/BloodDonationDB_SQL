
/*
SQL Project On 
Blood Donation Management System
Project Submitted By
Sharmin Sultana
Trainee Id: 1261105
Batch ID: ESAD-CS/PNTL-A/45/01
*/

--Query Script


USE BloodDonationDB
GO

--JOIN QUERY FOR DATE WISE BLOOD REQUEST

SELECT bs.bloodGroupID,bg.bloodGroupName,br.requestDate FROM BloodRequest br
INNER JOIN BloodGroups bg ON br.bloodGroupID=bg.bloodGroupID
INNER JOIN BloodStock bs ON bg.bloodGroupID=bs.bloodGroupID
WHERE br.requestDate='2021-01-01'
GO

--JOIN QUERY FOR HOSPITAL WISE BLOOD REQUEST

SELECT h.hospitalName,br.bloodGroupID,bg.bloodGroupName,COUNT(br.quantity) AS 'Total Blood Request' FROM BloodRequest br
INNER JOIN BloodGroups bg ON br.bloodGroupID=bg.bloodGroupID
INNER JOIN BloodStock bs ON bg.bloodGroupID=bs.bloodGroupID
INNER JOIN Patient p ON p.bloodGroupID=bg.bloodGroupID
INNER JOIN Hospital h ON p.hospitalID=h.hospitalID
GROUP BY h.hospitalName,br.bloodGroupID,bg.bloodGroupName
HAVING (h.hospitalName='Ad-Din Women''s Medical College Hospital')
GO

--SUBQUERY FOR BLOOD REQUEST WHERE QUANTITY>1

SELECT hospitalName,bloodGroupName FROM
(SELECT h.hospitalName,br.bloodGroupID,bg.bloodGroupName,COUNT(br.quantity) AS 'Total Blood Request' FROM BloodRequest br
INNER JOIN BloodGroups bg ON br.bloodGroupID=bg.bloodGroupID
INNER JOIN BloodStock bs ON bg.bloodGroupID=bs.bloodGroupID
INNER JOIN Patient p ON p.bloodGroupID=bg.bloodGroupID
INNER JOIN Hospital h ON p.hospitalID=h.hospitalID
GROUP BY h.hospitalName,br.bloodGroupID,bg.bloodGroupName
HAVING COUNT(br.quantity)>2) TBL1
 GO

--CALLING VIEW

SELECT * FROM vBloodRequestInfo
GO

--CALLING fnDateWiseRequest

SELECT * from fnDateWiseRequest (5)
GO

--CALLING fnMonthlyTotalRequest

SELECT dbo.fnMonthlyTotalRequest(12,2020) totalRequest
GO

-- INDEX DETAILS

EXEC sp_helpindex 'Hospital'
GO

-- STORED PROCEDURE DETAILS

EXEC sp_helptext spDeletePatient
GO

EXEC sp_helptext spUpdateBloodStock
GO


--TABLE DATA INSERT CHECK

SELECT * FROM BloodGroups
GO

SELECT * FROM Gender
GO

SELECT * FROM Members
GO

SELECT * FROM Donors
GO

SELECT * FROM Hospital
GO

SELECT * FROM BloodRequest
GO

SELECT * FROM Patient
GO

SELECT * FROM BloodStock
GO

