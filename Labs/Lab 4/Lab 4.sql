-- Drop existing foreign key constraints (if any)
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EMP_DEPT]'))
    ALTER TABLE EMPLOYEE DROP CONSTRAINT FK_EMP_DEPT;
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DEPT_MGR]'))
    ALTER TABLE DEPARTMENT DROP CONSTRAINT FK_DEPT_MGR;
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DEP_EMP]'))
    ALTER TABLE DEPENDENT DROP CONSTRAINT FK_DEP_EMP;
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LOC_DEPT]'))
    ALTER TABLE DEPT_LOCATIONS DROP CONSTRAINT FK_LOC_DEPT;
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PROJ_DEPT]'))
    ALTER TABLE PROJECT DROP CONSTRAINT FK_PROJ_DEPT;
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WORKS_EMP]'))
    ALTER TABLE WORKS_ON DROP CONSTRAINT FK_WORKS_EMP;
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_WORKS_PROJ]'))
    ALTER TABLE WORKS_ON DROP CONSTRAINT FK_WORKS_PROJ;
------------------------------------------------------------------------------------------------------------
USE master;
-- Create a db named COMPANY_yVagula. do NOT use master db.
IF DB_ID('COMPANY_yVagula') IS NULL
CREATE DATABASE COMPANY_yVagula;
GO
-- Use created db
USE COMPANY_yVagula;
GO

-- Create the DEPARTMENT table without foreign key constraints
CREATE TABLE DEPARTMENT (
    DNAME VARCHAR(15),
    DNUMBER INT PRIMARY KEY,
    MGRSSN CHAR(9),
    MGRSTARTDATE DATE
);

-- Create the EMPLOYEE table without foreign key constraints
CREATE TABLE EMPLOYEE (
    FNAME VARCHAR(15),
    MINIT CHAR(1),
    LNAME VARCHAR(15),
    SSN CHAR(9) PRIMARY KEY,
    BDATE DATE,
    ADDRESS VARCHAR(30),
    SEX CHAR(1),
    SALARY DECIMAL(10,2),
    SUPERSSN CHAR(9),
    DNO INT
);

-- Create the DEPENDENT table
CREATE TABLE DEPENDENT (
    ESSN CHAR(9),
    DEPENDENT_NAME VARCHAR(15),
    SEX CHAR(1),
    BDATE DATE,
    RELATIONSHIP VARCHAR(15),
    PRIMARY KEY (ESSN, DEPENDENT_NAME)
);

-- Create the DEPT_LOCATIONS table
CREATE TABLE DEPT_LOCATIONS (
    DNUMBER INT,
    DLOCATION VARCHAR(15),
    PRIMARY KEY (DNUMBER, DLOCATION)
);

-- Create the PROJECT table
CREATE TABLE PROJECT (
    PNAME VARCHAR(15),
    PNUMBER INT PRIMARY KEY,
    PLOCATION VARCHAR(15),
    DNUM INT
);

-- Create the WORKS_ON table
CREATE TABLE WORKS_ON (
    ESSN CHAR(9),
    PNO INT,
    HOURS DECIMAL(3,1),
    PRIMARY KEY (ESSN, PNO)
);

-------------------------------------------------------------------------------------

-- Insert data into EMPLOYEE
INSERT INTO EMPLOYEE VALUES ('James', 'E', 'Borg', '888665555', '1927-11-10', '450 Stone, Houston, TX', 'M', 55000, NULL, 1);
INSERT INTO EMPLOYEE VALUES ('Jennifer', 'S', 'Wallace', '987654321', '1931-06-20', '291 Berry, Bellaire, TX', 'F', 43000, '888665555', 4);
INSERT INTO EMPLOYEE VALUES ('Franklin', 'T', 'Wong', '333445555', '1945-12-08', '638 Voss, Houston, TX', 'M', 40000, '888665555', 5);
INSERT INTO EMPLOYEE VALUES ('John', 'B', 'Smith', '123456789', '1955-01-09', '731 Fondren, Houston, TX', 'M', 30000, '987654321', 5);
INSERT INTO EMPLOYEE VALUES ('Joyce', 'A', 'English', '453453453', '1962-07-31', '5631 Rice, Houston, TX', 'F', 25000, '333445555', 5);
INSERT INTO EMPLOYEE VALUES ('Ramesh', 'K', 'Narayan', '666884444', '1952-09-15', '975 Fire Oak, Humble, TX', 'M', 38000, '333445555', 5);
INSERT INTO EMPLOYEE VALUES ('Ahmad', 'V', 'Jabbar', '987987987', '1959-03-29', '980 Dallas, Houston, TX', 'M', 25000, '987654321', 4);
INSERT INTO EMPLOYEE VALUES ('Alicia', 'J', 'Zelaya', '999887777', '1958-07-19', '3321 Castle, Spring, TX', 'F', 25000, '987654321', 4);
INSERT INTO EMPLOYEE (FNAME, MINIT, LNAME, SSN, BDATE, ADDRESS, SEX, SALARY, SUPERSSN, DNO)
VALUES ('John', 'D', 'Doe', '999999999', '1990-01-01', '123 Main St, Anytown, USA', 'M', 50000, '123456789', 5);

-- Insert data into DEPARTMENT
INSERT INTO DEPARTMENT VALUES ('Headquarters', 1, '888665555', '1971-06-19');
INSERT INTO DEPARTMENT VALUES ('Administration', 4, '987654321', '1985-01-01');
INSERT INTO DEPARTMENT VALUES ('Research', 5, '333445555', '1978-05-22');
INSERT INTO DEPARTMENT VALUES ('Automation', 7, '123456789', '2005-10-06');

-- Insert data into DEPENDENT
INSERT INTO DEPENDENT VALUES ('123456789', 'Alice', 'F', '1978-12-31', 'Daughter');
INSERT INTO DEPENDENT VALUES ('123456789', 'Elizabeth', 'F', '1957-05-05', 'Spouse');
INSERT INTO DEPENDENT VALUES ('123456789', 'Michael', 'M', '1978-01-01', 'Son');
INSERT INTO DEPENDENT VALUES ('333445555', 'Alice', 'F', '1976-04-05', 'Daughter');
INSERT INTO DEPENDENT VALUES ('333445555', 'Joy', 'F', '1948-05-03', 'Spouse');
INSERT INTO DEPENDENT VALUES ('333445555', 'Theodore', 'M', '1973-10-25', 'Son');
INSERT INTO DEPENDENT VALUES ('987654321', 'Abner', 'M', '1932-02-29', 'Spouse');
INSERT INTO DEPENDENT (ESSN, DEPENDENT_NAME, SEX, BDATE, RELATIONSHIP)
VALUES ('999999999', 'Jane', 'F', '2010-05-05', 'Daughter');

-- Insert data into DEPT_LOCATIONS
INSERT INTO DEPT_LOCATIONS VALUES (1, 'Houston');
INSERT INTO DEPT_LOCATIONS VALUES (4, 'Stafford');
INSERT INTO DEPT_LOCATIONS VALUES (5, 'Bellaire');
INSERT INTO DEPT_LOCATIONS VALUES (5, 'Sugarland');
INSERT INTO DEPT_LOCATIONS VALUES (5, 'Houston');

-- Insert data into PROJECT
INSERT INTO PROJECT VALUES ('ProductX', 1, 'Bellaire', 5);
INSERT INTO PROJECT VALUES ('ProductY', 2, 'Sugarland', 5);
INSERT INTO PROJECT VALUES ('ProductZ', 3, 'Houston', 5);
INSERT INTO PROJECT VALUES ('Computerization', 10, 'Stafford', 4);
INSERT INTO PROJECT VALUES ('Reorganization', 20, 'Houston', 1);
INSERT INTO PROJECT VALUES ('Newbenefits', 30, 'Stafford', 4);

-- Insert data into WORKS_ON
INSERT INTO WORKS_ON VALUES ('123456789', 1, 32.5);
INSERT INTO WORKS_ON VALUES ('123456789', 2, 7.5);
INSERT INTO WORKS_ON VALUES ('333445555', 2, 10);
INSERT INTO WORKS_ON VALUES ('333445555', 3, 10);
INSERT INTO WORKS_ON VALUES ('333445555', 10, 10);
INSERT INTO WORKS_ON VALUES ('333445555', 20, 10);
INSERT INTO WORKS_ON VALUES ('453453453', 1, 20);
INSERT INTO WORKS_ON VALUES ('453453453', 2, 20);
INSERT INTO WORKS_ON VALUES ('666884444', 3, 40);
INSERT INTO WORKS_ON VALUES ('888665555', 20, NULL);
INSERT INTO WORKS_ON VALUES ('987654321', 20, 15);
INSERT INTO WORKS_ON VALUES ('987654321', 30, 20);
INSERT INTO WORKS_ON VALUES ('987987987', 10, 35);
INSERT INTO WORKS_ON VALUES ('987987987', 30, 5);
INSERT INTO WORKS_ON VALUES ('999887777', 10, 10);
INSERT INTO WORKS_ON VALUES ('999887777', 30, 30);
INSERT INTO WORKS_ON VALUES ('999999999', 1, 20);

----------------------------------------------------------------------------------------

-- Now add the foreign key constraints
ALTER TABLE DEPARTMENT
ADD CONSTRAINT FK_DEPT_MGR FOREIGN KEY (MGRSSN) REFERENCES EMPLOYEE(SSN);

ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_EMP_DEPT FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNUMBER);

ALTER TABLE DEPENDENT
ADD CONSTRAINT FK_DEP_EMP FOREIGN KEY (ESSN) REFERENCES EMPLOYEE(SSN);

ALTER TABLE DEPT_LOCATIONS
ADD CONSTRAINT FK_LOC_DEPT FOREIGN KEY (DNUMBER) REFERENCES DEPARTMENT(DNUMBER);

ALTER TABLE PROJECT
ADD CONSTRAINT FK_PROJ_DEPT FOREIGN KEY (DNUM) REFERENCES DEPARTMENT(DNUMBER);

ALTER TABLE WORKS_ON
ADD CONSTRAINT FK_WORKS_EMP FOREIGN KEY (ESSN) REFERENCES EMPLOYEE(SSN);

ALTER TABLE WORKS_ON
ADD CONSTRAINT FK_WORKS_PROJ FOREIGN KEY (PNO) REFERENCES PROJECT(PNUMBER);

---------------------------------------------------------------------------------------

-- Insert Joe Anderson as a spouse for Joyce English
INSERT INTO DEPENDENT (ESSN, DEPENDENT_NAME, SEX, BDATE, RELATIONSHIP)
VALUES ('453453453', 'Joe Anderson', 'M', NULL, 'Spouse');

-- Insert Erica as a daughter for Jenifer Wallace
INSERT INTO DEPENDENT (ESSN, DEPENDENT_NAME, SEX, BDATE, RELATIONSHIP)
VALUES ('987654321', 'Erica', 'F', GETDATE(), 'Daughter');

-- Insert a new entry in the WORKS_ON table for Jenifer Wallace
INSERT INTO WORKS_ON (ESSN, PNO, HOURS)
VALUES ('987654321', 10, 0);

SELECT * FROM DEPENDENT
SELECT * FROM WORKS_ON
-- Q1---------------------------------------------------------------
SELECT 
    D.DNUMBER, 
    D.DNAME, 
    E.FNAME AS EMP_FNAME, 
    E.LNAME AS EMP_LNAME, 
    S.FNAME AS SUP_FNAME, 
    S.LNAME AS SUP_LNAME
FROM 
    DEPARTMENT D
LEFT JOIN 
    EMPLOYEE E ON D.DNUMBER = E.DNO
LEFT JOIN 
    EMPLOYEE S ON E.SUPERSSN = S.SSN
ORDER BY 
    D.DNUMBER, E.FNAME;
-- Q1_1---------------------------------------------------------------
	SELECT 
    D.DNUMBER, 
    D.DNAME, 
    E.FNAME AS EMP_FNAME, 
    E.LNAME AS EMP_LNAME, 
    S.FNAME AS SUP_FNAME, 
    S.LNAME AS SUP_LNAME
FROM 
    DEPARTMENT D
INNER JOIN 
    EMPLOYEE E ON D.DNUMBER = E.DNO
LEFT JOIN 
    EMPLOYEE S ON E.SUPERSSN = S.SSN
ORDER BY 
    D.DNUMBER, E.FNAME;
-- Q2---------------------------------------------------------------
	SELECT 
    E.FNAME, 
    E.LNAME
FROM 
    EMPLOYEE E
WHERE 
    E.SSN IN (SELECT MGRSSN FROM DEPARTMENT)
    AND E.SSN NOT IN (SELECT ESSN FROM DEPENDENT);
-- Q2_1---------------------------------------------------------------
	SELECT 
    E.SSN, 
    E.LNAME
FROM 
    EMPLOYEE E
WHERE 
    E.SEX = 'F'
    AND E.SSN IN (SELECT ESSN FROM DEPENDENT WHERE RELATIONSHIP = 'Spouse')
    AND (SELECT COUNT(*) FROM WORKS_ON W WHERE W.ESSN = E.SSN) >= 3;
-- Q3---------------------------------------------------------------
SELECT 
    E.FNAME, 
    E.LNAME
FROM 
    EMPLOYEE E
WHERE 
    E.DNO = (SELECT DNUMBER FROM DEPARTMENT WHERE DNAME = 'Research')
    AND E.SSN IN (SELECT ESSN FROM DEPENDENT WHERE RELATIONSHIP = 'Spouse')
    AND E.SSN NOT IN (SELECT ESSN FROM DEPENDENT WHERE RELATIONSHIP IN ('Son', 'Daughter'));
-- Q4---------------------------------------------------------------
SELECT 
    E.LNAME
FROM 
    EMPLOYEE E
WHERE 
    E.SSN IN (SELECT ESSN FROM DEPENDENT WHERE RELATIONSHIP = 'Spouse')
    AND E.SSN NOT IN (SELECT ESSN FROM DEPENDENT WHERE RELATIONSHIP = 'Son')
    AND E.SSN IN (SELECT ESSN FROM DEPENDENT WHERE RELATIONSHIP = 'Daughter');

-- Q5/Extra Credit---------------------------------------------------------------
SELECT 
    DISTINCT E.LNAME, 
    E.SSN
FROM 
    EMPLOYEE E
WHERE 
    E.SSN IN (
        SELECT W.ESSN 
        FROM WORKS_ON W
        JOIN PROJECT P ON W.PNO = P.PNUMBER
        WHERE (
            SELECT COUNT(DISTINCT E2.SSN)
            FROM WORKS_ON W2
            JOIN EMPLOYEE E2 ON W2.ESSN = E2.SSN
            WHERE W2.PNO = P.PNUMBER AND E2.SEX = 'F'
        ) > (
            SELECT COUNT(DISTINCT E2.SSN)
            FROM WORKS_ON W2
            JOIN EMPLOYEE E2 ON W2.ESSN = E2.SSN
            WHERE W2.PNO = P.PNUMBER AND E2.SEX = 'M'
        )
    );