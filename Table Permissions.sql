-- create demo database
Create Database Demo
GO
Use Demo
GO

-- create sample table
CREATE TABLE dbo.Payrole (
PayroleID INT IDENTITY(1,1),
FirstName VARCHAR(20) NOT NULL,
MiddleName VARCHAR(20) NULL,
SurName VARCHAR(20) NOT NULL,
SSN CHAR(9) NOT NULL,
Salary INT NOT NULL,
CONSTRAINT PK_Payrole PRIMARY KEY (PayroleID)
);


-- insert dummy data
INSERT INTO dbo.Payrole (FirstName, MiddleName, SurName, SSN, Salary)
VALUES ('John', 'Mark', 'Doe', '111223333', 50000);
INSERT INTO dbo.Payrole (FirstName, MiddleName, SurName, SSN, Salary)
VALUES ('Jane', 'Eyre', 'Doe', '222334444', 65000);


-- create roles
CREATE ROLE HR_Payrole;
GO 
CREATE ROLE HR_Intern;
GO 
GRANT SELECT ON dbo.Payrole TO HR_Payrole;
GRANT SELECT ON dbo.Payrole (PayroleID, FirstName, MiddleName, SurName) TO HR_Intern;



-- create users and assign role
CREATE USER HR_admin WITHOUT LOGIN;
GO 
EXEC sp_addrolemember @membername = 'HR_admin', @rolename = 'HR_Payrole';
GO 
CREATE USER SummerIntern WITHOUT LOGIN;
GO 
EXEC sp_addrolemember @membername = 'SummerIntern', @rolename = 'HR_Intern';
GO 


-- Test Select
EXECUTE AS USER = 'HR_admin';
GO
SELECT * FROM dbo.Payrole;
GO 
REVERT;
GO

EXECUTE AS USER = 'SummerIntern';
GO
SELECT * FROM dbo.Payrole;
GO 
REVERT;
GO


EXECUTE AS USER = 'SummerIntern';
GO
SELECT PayroleID, FirstName, MiddleName, SurName FROM dbo.Payrole;
GO 
REVERT;
GO


-- Now Try as View
CREATE VIEW SecurePayRole AS
SELECT PayroleID, FirstName, MiddleName, SurName FROM dbo.Payrole; 
GO
GRANT SELECT ON dbo.SecurePayRole TO HR_Intern;
GO


EXECUTE AS USER = 'SummerIntern';
GO
SELECT * from dbo.SecurePayRole
REVERT;
GO
