-- create new blank database
Create Database Example
GO

-- switch to new database
Use Example
GO

-- create example table
CREATE TABLE [dbo].[Senstive](
 [PatientId] [int] IDENTITY(1,1), 
 [FirstName] [nvarchar](50) NULL,
 [LastName] [nvarchar](50) NULL, 
 [Postcode] [char](6) NULL,
 [City] [char](30) NULL,
 [BirthDate] [date] NOT NULL
 PRIMARY KEY CLUSTERED ([PatientId] ASC) ON [PRIMARY] )
GO

-- insert dummy data
Insert into Example.dbo.Senstive ([FirstName],[LastName],[Postcode],[City],[BirthDate])   
VALUES ('John','Smith','W6 NZ3','London','1980-11-26');
Insert into Example.dbo.Senstive ([FirstName],[LastName],[Postcode],[City],[BirthDate])   
VALUES ('Anna','Smith','W6 NZ3','London','1982-01-19'); 
Insert into Example.dbo.Senstive ([FirstName],[LastName],[Postcode],[City],[BirthDate])  
VALUES ('Zoe','Smith','W6 NZ3','London','1018-01-19');

-- check contents of table
Select * from Example.dbo.Senstive
