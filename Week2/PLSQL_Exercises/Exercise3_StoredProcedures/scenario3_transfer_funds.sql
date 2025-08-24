CREATE TABLE BankAccounts (
    AccountID NUMBER PRIMARY KEY,
    AccountHolder VARCHAR2(50),
    Balance NUMBER
);


INSERT INTO BankAccounts VALUES (1, 'Amit Verma', 15000);
INSERT INTO BankAccounts VALUES (2, 'Sneha Sharma', 12000);
INSERT INTO BankAccounts VALUES (3, 'Rohit Rao', 8000);


CREATE OR REPLACE PROCEDURE TransferFunds (
    fromAccID IN NUMBER,
    toAccID IN NUMBER,
    amount IN NUMBER
) AS
    fromBalance NUMBER;
BEGIN
    SELECT Balance INTO fromBalance
    FROM BankAccounts
    WHERE AccountID = fromAccID;

    IF fromBalance >= amount THEN
        UPDATE BankAccounts
        SET Balance = Balance - amount
        WHERE AccountID = fromAccID;

        UPDATE BankAccounts
        SET Balance = Balance + amount
        WHERE AccountID = toAccID;

        DBMS_OUTPUT.PUT_LINE('Transferred ₹' || amount || 
                             ' from Account ID ' || fromAccID || 
                             ' to Account ID ' || toAccID);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Insufficient balance in Account ID ' || fromAccID);
    END IF;
END;
/


BEGIN
    TransferFunds(1, 2, 5000);
END;
/


SELECT * FROM BankAccounts;
