CREATE DATABASE studentsDBprac3
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_South Africa.1252'
    LC_CTYPE = 'English_South Africa.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

CREATE SCHEMA Uni;
	
CREATE TABLE Uni.DegreeProgram (
	dID int PRIMARY KEY,
    dCode varchar(255) UNIQUE,
    dName varchar(255),
    dYears int,
    dFaculty varchar(255)
);

CREATE TABLE Uni.Student (
	sID int PRIMARY KEY,
	sNumber varchar(6),
	sFullNames varchar(255),
	sDateOfBirth varchar(255),
	sDegreeCode varchar(255),
	sYearOfStudy int,
    FOREIGN KEY (sDegreeCode) REFERENCES Uni.DegreeProgram(dCode)
);

CREATE TABLE Uni.Undergraduate (
    uCourseRegistration varchar(255)
) INHERITS(Uni.Student);

CREATE TABLE Uni.DeletedUndergrad (
	deletionTime date,
	deleter int
) INHERITS(Uni.Undergraduate);

CREATE TABLE Uni.Postgraduate (
    pCategory varchar(255),
    pSupervisor varchar(255)
) INHERITS(Uni.Student);

CREATE TABLE Uni.DeletedPostgrad (
	deletionTime date,
	deleter int
) INHERITS(Uni.Postgraduate);
    
CREATE TABLE Uni.Course (
	cID int PRIMARY KEY,
    cCode varchar(6),
    cName varchar(255),
    cDepartment varchar(255),
    cCredits int
);

CREATE SEQUENCE Uni.degreeSeq START 1;
CREATE SEQUENCE Uni.courseSeq START 1;
CREATE SEQUENCE Uni.studentSeq START 1;

CREATE OR REPLACE FUNCTION Uni.ageInYears(dob TEXT)
RETURNS text
AS $$
BEGIN
	RETURN age(dob::timestamp);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Uni.isRegisteredFor(student text, course text)
RETURNS BOOLEAN
AS $$
BEGIN
    RETURN EXISTS (
        SELECT *
        FROM uni.undergraduate
        WHERE sNumber = student AND position(course in uCourseRegistration) > 0
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Uni.isValidCourseCode(coursecode text)
RETURNS BOOLEAN
AS $$
BEGIN
    RETURN EXISTS (
        SELECT *
        FROM uni.course
        WHERE cCode = coursecode
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Uni.isValidDegreeCode(degreecode text)
RETURNS BOOLEAN
AS $$
BEGIN
    RETURN EXISTS (
        SELECT *
        FROM uni.degreeprogram
        WHERE dCode = degreecode
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Uni.hasValidCourseCodes(coursecodes text)
RETURNS BOOLEAN
AS $$
DECLARE
	str text;
    ret boolean;
BEGIN
	str := coursecodes;
    ret := true;
    
    LOOP
    EXIT WHEN position(',' in str) = 0 OR ret = false;
    ret := uni.isvalidcoursecode(substring(str from 1 for 6));
    str := substring(str from 8 for char_length(str));
    END LOOP;
    
    IF (ret = false) THEN
    RETURN false;
    END IF;
    
    IF (char_length(str) = 6) THEN
    ret := uni.isvalidcoursecode(str);
    END IF;
    
    RETURN ret;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION uni.coursecodefrequency(coursecode text, courseregistration text)
RETURNS INT
AS $$
DECLARE
	counter int;
    str text;
BEGIN
	counter = 0;
	str := courseregistration;
    
    LOOP
    EXIT WHEN position(coursecode in str) = 0;
    str := substring(str from position(coursecode in str) + 6 for char_length(str));
    counter := counter + 1;
    END LOOP;
    
    RETURN counter;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION uni.hasDuplicateCourseCodes(courseregistration text)
RETURNS BOOLEAN
AS $$
DECLARE
	str text;
    ret boolean;
BEGIN
	str := courseregistration;
    ret := false;
    
    LOOP
    EXIT WHEN position(',' in str) = 0 OR ret = true;
    ret := uni.coursecodefrequency(substring(str from 1 for 6), courseregistration) > 1;
    str := substring(str from 8 for char_length(str));
    END LOOP;
    
    IF (ret = true) THEN
    RETURN true;
    END IF;
    
    IF (char_length(str) = 6) THEN
    ret := uni.coursecodefrequency(str, courseregistration) > 1;
    END IF;
    
    RETURN ret;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION uni.isFinalYearStudent(student text)
RETURNS BOOLEAN
AS $$
BEGIN
    RETURN EXISTS (
        SELECT *
        FROM uni.undergraduate, uni.degreeprogram
        WHERE undergraduate.uDegreeCode = degreeprogram.dCode 
            AND undergraduate.sNumber = student 
            AND undergraduate.uYearOfStudy = degreeprogram.dYears
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION uni.isFullTime(postNumber text)
RETURNS BOOLEAN
AS $$
BEGIN
  RETURN EXISTS (
    SELECT *
    FROM uni.Postgraduate
    WHERE sNumber = postNumber AND pCategory = 'full time'
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION uni.isPartTime(postNumber text)
RETURNS BOOLEAN
AS $$
BEGIN
  RETURN EXISTS (
    SELECT *
    FROM uni.Postgraduate
    WHERE sNumber = postNumber AND pCategory = 'part time'
        );
END;
$$ LANGUAGE plpgsql;

-- ================================================= TRIGGERS

CREATE OR REPLACE FUNCTION check_valid_degree_code()
RETURNS TRIGGER
AS $$
BEGIN
	IF (uni.hasValidCourseCodes(NEW.sDegreeCode)) THEN ELSE
		RAISE EXCEPTION 'Degree code not valid';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_valid_course_codes()
RETURNS TRIGGER
AS $$
BEGIN
	IF (uni.isValidDegreeCode(NEW.uCourseRegistration)) THEN ELSE
		RAISE EXCEPTION 'Course registration not valid';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_valid_degree
	BEFORE INSERT OR UPDATE ON uni.student
	FOR EACH ROW
	EXECUTE PROCEDURE check_valid_degree_code();
	
CREATE TRIGGER check_valid_degree
	BEFORE INSERT OR UPDATE ON uni.undergraduate
	FOR EACH ROW
	EXECUTE PROCEDURE check_valid_degree_code();
	
CREATE TRIGGER check_valid_degree
	BEFORE INSERT OR UPDATE ON uni.postgraduate
	FOR EACH ROW
	EXECUTE PROCEDURE check_valid_degree_code();
	
CREATE TRIGGER check_valid_course_registration
	BEFORE INSERT OR UPDATE ON uni.undergraduate
	FOR EACH ROW
	EXECUTE PROCEDURE check_valid_course_codes();