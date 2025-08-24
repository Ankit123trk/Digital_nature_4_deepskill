CREATE TABLE Employees (
    EmpID NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    Department VARCHAR2(30),
    Salary NUMBER
);


INSERT INTO Employees VALUES (101, 'Ravi Sharma', 'IT', 50000);
INSERT INTO Employees VALUES (102, 'Neha Joshi', 'HR', 45000);
INSERT INTO Employees VALUES (103, 'Sanjay Mehta', 'IT', 60000);
INSERT INTO Employees VALUES (104, 'Pooja Patel', 'Finance', 55000);
INSERT INTO Employees VALUES (105, 'Amit Reddy', 'HR', 48000);


CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    deptName IN VARCHAR2,
    bonusPercent IN NUMBER
) AS
BEGIN
    FOR emp IN (
        SELECT EmpID FROM Employees WHERE Department = deptName
    ) LOOP
        UPDATE Employees
        SET Salary = Salary + (Salary * bonusPercent / 100)
        WHERE EmpID = emp.EmpID;

        DBMS_OUTPUT.PUT_LINE('Bonus applied to Employee ID: ' || emp.EmpID);
    END LOOP;
END;
/


BEGIN
    UpdateEmployeeBonus('HR', 10);
END;
/


SELECT * FROM Employees;
