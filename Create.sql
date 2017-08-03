-- Database: prac2

-- DROP DATABASE prac2;

CREATE DATABASE prac2
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

CREATE TABLE DegreeProgram (
    dCode varchar(255) PRIMARY KEY,
    dName varchar(255),
    dYears int,
    dFaculty varchar(255)
);

CREATE TABLE Undergraduate (
   	uNumber varchar(6) PRIMARY KEY,
    uFullNames varchar(255),
    uDateOfBirth varchar(255),
    uDegreeCode varchar(255),
    uYearOfStudy int,
    uCourseRegistration varchar(255),
    FOREIGN KEY (uDegreeCode) REFERENCES DegreeProgram(dCode)
);


CREATE TABLE Postgraduate (
    pNumber varchar(6) PRIMARY KEY,
    pFullNames varchar(255),
    pDateOfBirth varchar(255),
    pDegreeCode varchar(255),
    pYearOfStudy int,
    pCategory varchar(255),
    pSupervisor varchar(255),
    FOREIGN KEY (pDegreeCode) REFERENCES DegreeProgram(dCode)
);
    
CREATE TABLE Course (
    cCode varchar(6) PRIMARY KEY,
    cName varchar(255),
    cDepartment varchar(255),
    cCredits int
);

INSERT INTO DegreeProgram VALUES
    ('BSc', 'Bachelor of Science', 3, 'EBIT'),
    ('BIT', 'Bachelor of IT', 4, 'EBIT'),
    ('PhD', 'Philosophiae Doctor', 5, 'EBIT');
    
INSERT INTO Course VALUES
    ('COS301', 'Software Engineering', 'Computer Science', 40),
    ('COS326', 'Database Systems', 'Computer Science', 20),
    ('MTH301', 'Discrete Mathematics', 'Mathematics', 15),
    ('PHL301', 'Logical Reasoning', 'Philosophy', 15);
    
INSERT INTO Undergraduate VALUES
    ('140010', 'Mr Minal Pramlall', '10-01-1996', 'BSc', 3, 'COS301,COS326,MTH301'),
    ('140015', 'Ms Leandra Methven', '25-05-1995', 'BSc', 3, 'COS301,PHL301,MTH301'),
    ('131120', 'Mr Kurt Lourens', '30-01-1995', 'BIT', 3, 'COS301,COS326,PHL301'),
    ('131140', 'Mr Keith Kinsey', '20-02-1996', 'BIT', 4, 'COS301,COS326,MTH301,PHL301');
     
INSERT INTO Postgraduate VALUES
    ('101122', 'Mr Tristan Bowman', '15-06-1987', 'PhD', 2, 'full time', 'Mr Emilio Singh'),
    ('121101', 'Mr Jason van Eck', '27-04-1985', 'PhD', 3, 'part time', 'Mr Emilio Singh');



CREATE FUNCTION isFullTime(@postNumber varchar(6))
RETURNS BOOLEAN
AS
BEGIN
  RETURN EXISTS (
    SELECT *
    FROM Postgraduate
    WHERE pNumber = @postNumber AND pCategory = 'full time'
        );
END

CREATE FUNCTION isPartTime(@postNumber varchar(6))
RETURNS BOOLEAN
AS
BEGIN
  RETURN EXISTS (
    SELECT *
    FROM Postgraduate
    WHERE pNumber = @postNumber AND pCategory = 'part time'
        );
END
