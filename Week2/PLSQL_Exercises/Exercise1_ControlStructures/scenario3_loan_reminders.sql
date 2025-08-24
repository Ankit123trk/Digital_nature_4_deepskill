CREATE TABLE LoanCustomers (
    LoanID NUMBER PRIMARY KEY,
    CustomerName VARCHAR2(50),
    DueDate DATE
);


INSERT INTO LoanCustomers VALUES (1, 'Anjali Sharma', SYSDATE + 5);
INSERT INTO LoanCustomers VALUES (2, 'Ravi Kumar', SYSDATE + 15);
INSERT INTO LoanCustomers VALUES (3, 'Sneha Reddy', SYSDATE + 40);
INSERT INTO LoanCustomers VALUES (4, 'Vishal Jain', SYSDATE + 25);


BEGIN
    FOR loan IN (
        SELECT LoanID, CustomerName, DueDate
        FROM LoanCustomers
        WHERE DueDate <= SYSDATE + 30
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Reminder: Loan ID ' || loan.LoanID || ' for ' || loan.CustomerName ||
                             ' is due on ' || TO_CHAR(loan.DueDate, 'DD-MON-YYYY'));
    END LOOP;
END;
/


SELECT * FROM LoanCustomers;