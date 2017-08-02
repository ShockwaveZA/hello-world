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

CREATE TABLE Student (
    sNumber varchar(6) PRIMARY KEY,
    sFullNames varchar(255),
    sDateOfBirth date,
    sDegreeCode varchar(255),
    sYearOfStudy int,
    FOREIGN KEY (sDegreeCode) REFERENCES DegreeProgram(dCode)
);

CREATE TABLE Undergraduate (
   	uNumber varchar(6) PRIMARY KEY,
    uCourseRegistration varchar(255),
    FOREIGN KEY (uNumber) REFERENCES Student(sNumber)
);


CREATE TABLE Postgraduate (
    pNumber varchar(6) PRIMARY KEY,
    pCategory varchar(255),
    pSupervisor varchar(255),
    FOREIGN KEY (pNumber) REFERENCES Student(sNumber)
);

CREATE TABLE DegreeProgram (
    dCode varchar(255) PRIMARY KEY,
    dName varchar(255),
    dYears int,
    dFaculty varchar(255)
);
    
CREATE TABLE Course (
    cCode varchar(6) PRIMARY KEY,
    cName varchar(255),
    cDepartment varchar(255),
    cCredits int
);
