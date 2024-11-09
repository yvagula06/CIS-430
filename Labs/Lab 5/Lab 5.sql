USE master;
-- Create a db named COMPANY_yVagula. do NOT use master db.
IF DB_ID('COMPANY_yVagula') IS NULL
CREATE DATABASE COMPANY_yVagula;
GO
-- Use created db
USE COMPANY_yVagula;
GO

-- (1-1)-----------------------------------------------------------------------------------
-- Create the view VDept_Budget
CREATE VIEW VDept_Budget AS
SELECT D.DNAME AS Dept_Name, D.DNUMBER AS Dept_Number, COUNT(E.SSN) AS No_Emp
FROM DEPARTMENT D
LEFT JOIN EMPLOYEE E ON D.DNUMBER = E.DNO
GROUP BY D.DNAME, D.DNUMBER;

SELECT * FROM VDept_Budget;
-- (1-2)-----------------------------------------------------------------------------------
CREATE TABLE Dept_Budget (
    Dept_Name VARCHAR(15),
    Dept_Number INT,
    No_Emp INT
);

INSERT INTO Dept_Budget (Dept_Name, Dept_Number, No_Emp)
SELECT D.DNAME AS Dept_Name, D.DNUMBER AS Dept_Number, COUNT(E.SSN) AS No_Emp
FROM DEPARTMENT D
LEFT JOIN EMPLOYEE E ON D.DNUMBER = E.DNO
GROUP BY D.DNAME, D.DNUMBER;

SELECT * FROM Dept_Budget;
-- (2-1) & (2-2)-----------------------------------------------------------------------------------
INSERT INTO EMPLOYEE (FNAME, MINIT, LNAME, SSN, BDATE, ADDRESS, SEX, SALARY, SUPERSSN, DNO)
VALUES ('Yuvaraj', 'N', 'Vagula', '777777777', '2006-05-01', '2121 Euclid Ave, Cleveland, OH', 'M', 50000, NULL, 1),
       ('John', 'B', 'Doe', '222222222', '1991-02-02', '456 dog St, Shaker, OH', 'F', 50000, NULL, 1);

SELECT * FROM VDept_Budget;

SELECT * FROM Dept_Budget;
-- (3)-----------------------------------------------------------------------------------
-- Drop the existing view if it exists
IF OBJECT_ID('VDept_Budget', 'V') IS NOT NULL
    DROP VIEW VDept_Budget;
GO

-- Create the view with the additional columns
CREATE VIEW VDept_Budget AS
SELECT D.DNAME AS Dept_Name, D.DNUMBER AS Dept_Number, COUNT(E.SSN) AS No_Emp, SUM(E.SALARY) AS Sum_Salary, AVG(E.SALARY) AS Ave_Salary
FROM DEPARTMENT D
LEFT JOIN EMPLOYEE E ON D.DNUMBER = E.DNO
GROUP BY D.DNAME, D.DNUMBER;
GO

-- Display the content of the updated view
SELECT * FROM VDept_Budget;
GO

-- Drop the existing table if it exists
DROP TABLE IF EXISTS Dept_Budget;
GO

-- Create the table Dept_Budget with the new schema
CREATE TABLE Dept_Budget (
    Dept_Name VARCHAR(15),
    Dept_Number INT,
    No_Emp INT,
    Sum_Salary DECIMAL(10, 2),
    Ave_Salary DECIMAL(10, 2)
);
GO

-- Populate the table Dept_Budget with the new schema
INSERT INTO Dept_Budget (Dept_Name, Dept_Number, No_Emp, Sum_Salary, Ave_Salary)
SELECT D.DNAME AS Dept_Name, D.DNUMBER AS Dept_Number, COUNT(E.SSN) AS No_Emp, SUM(E.SALARY) AS Sum_Salary, AVG(E.SALARY) AS Ave_Salary
FROM DEPARTMENT D
LEFT JOIN EMPLOYEE E ON D.DNUMBER = E.DNO
GROUP BY D.DNAME, D.DNUMBER;
GO

-- Display the content of the updated table
SELECT * FROM Dept_Budget;
GO
-- (Part 2)-------------------------------------
-- Drop the existing stored procedure if it exists
DROP PROCEDURE IF EXISTS SP_Report_NEW_Budget;
GO

-- Create the stored procedure
CREATE PROCEDURE SP_Report_NEW_Budget
AS
BEGIN
    -- Create the new table NEW_Dept_Budget
    CREATE TABLE NEW_Dept_Budget (
        Dept_No INT,
        Dept_Name CHAR(30),
        COUNT_Emp INT,
        New_SUM_Salary INT,
        New_AVE_Salary INT
    );

    -- Check if the view VDept_Budget is empty
    IF (SELECT COUNT(*) FROM VDept_Budget) > 0
    BEGIN
        -- Declare cursor for the view VDept_Budget
        DECLARE cur CURSOR FOR 
        SELECT Dept_Number, Dept_Name, No_Emp, Sum_Salary, Ave_Salary
        FROM VDept_Budget;

        -- Declare variables to hold the cursor data
        DECLARE @Dept_No INT, @Dept_Name CHAR(30), @COUNT_Emp INT, @Sum_Salary INT, @Ave_Salary INT;
        DECLARE @New_SUM_Salary INT, @New_AVE_Salary INT;

        -- Open the cursor
        OPEN cur;

        -- Fetch the cursor data
        FETCH NEXT FROM cur INTO @Dept_No, @Dept_Name, @COUNT_Emp, @Sum_Salary, @Ave_Salary;

        -- Loop through the cursor data
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Calculate the new sum and average salary based on department number
            IF @Dept_No = 1
                SET @New_SUM_Salary = @Sum_Salary * 1.1;
            ELSE IF @Dept_No = 4
                SET @New_SUM_Salary = @Sum_Salary * 1.2;
            ELSE IF @Dept_No = 5
                SET @New_SUM_Salary = @Sum_Salary * 1.3;
            ELSE IF @Dept_No = 7
                SET @New_SUM_Salary = @Sum_Salary * 1.4;
            ELSE
                SET @New_SUM_Salary = @Sum_Salary;

            SET @New_AVE_Salary = @New_SUM_Salary / @COUNT_Emp;

            -- Insert data into the new table
            INSERT INTO NEW_Dept_Budget (Dept_No, Dept_Name, COUNT_Emp, New_SUM_Salary, New_AVE_Salary)
            VALUES (@Dept_No, @Dept_Name, @COUNT_Emp, @New_SUM_Salary, @New_AVE_Salary);

            -- Fetch the next row
            FETCH NEXT FROM cur INTO @Dept_No, @Dept_Name, @COUNT_Emp, @Sum_Salary, @Ave_Salary;
        END;

        -- Close and deallocate the cursor
        CLOSE cur;
        DEALLOCATE cur;
    END;
END;
GO

EXEC SP_Report_NEW_Budget;

SELECT * FROM NEW_Dept_Budget;