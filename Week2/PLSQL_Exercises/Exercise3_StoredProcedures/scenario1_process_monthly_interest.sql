-- Create the table
CREATE TABLE SavingsAccounts (
    AccountID NUMBER PRIMARY KEY,
    AccountHolder VARCHAR2(50),
    Balance NUMBER
);

-- Insert sample data
INSERT INTO SavingsAccounts VALUES (1, 'Nikhil Verma', 10000);
INSERT INTO SavingsAccounts VALUES (2, 'Ritu Sharma', 15000);
INSERT INTO SavingsAccounts VALUES (3, 'Amit Gupta', 20000);

-- Create stored procedure to process 1% interest
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest AS
BEGIN
    FOR acc IN (
        SELECT AccountID, Balance FROM SavingsAccounts
    ) LOOP
        UPDATE SavingsAccounts
        SET Balance = Balance + (Balance * 0.01)
        WHERE AccountID = acc.AccountID;

        DBMS_OUTPUT.PUT_LINE('Interest applied for Account ID: ' || acc.AccountID);
    END LOOP;
END;
/

-- Execute the procedure
BEGIN
    ProcessMonthlyInterest;
END;
/

-- View updated balances
SELECT * FROM SavingsAccounts;
