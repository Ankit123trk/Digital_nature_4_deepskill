CREATE TABLE VipCustomers (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    Balance NUMBER,
    IsVIP CHAR(1) DEFAULT 'N'
);


INSERT INTO VipCustomers VALUES (101, 'Arjun Mehta', 8000, 'N');
INSERT INTO VipCustomers VALUES (102, 'Kavita Rao', 15000, 'N');
INSERT INTO VipCustomers VALUES (103, 'Ramesh Iyer', 25000, 'N');
INSERT INTO VipCustomers VALUES (104, 'Sneha Kapoor', 7000, 'N');
INSERT INTO VipCustomers VALUES (105, 'Vikram Singh', 12000, 'N');


BEGIN
    FOR cust IN (
        SELECT CustomerID, Name, Balance FROM VipCustomers WHERE Balance > 10000
    ) LOOP
        UPDATE VipCustomers
        SET IsVIP = 'Y'
        WHERE CustomerID = cust.CustomerID;

        DBMS_OUTPUT.PUT_LINE('Promoted to VIP: ' || cust.Name || ' (Customer ID: ' || cust.CustomerID || ')');
    END LOOP;
END;
/


SELECT * FROM VipCustomers;
