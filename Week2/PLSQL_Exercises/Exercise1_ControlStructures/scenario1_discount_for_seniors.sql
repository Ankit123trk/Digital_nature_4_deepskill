CREATE TABLE SeniorCustomers (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    Age NUMBER,
    InterestRate NUMBER
);


INSERT INTO SeniorCustomers VALUES (1, 'Rajesh Verma', 65, 9.5);
INSERT INTO SeniorCustomers VALUES (2, 'Sunita Sharma', 58, 10.0);
INSERT INTO SeniorCustomers VALUES (3, 'Meena Joshi', 70, 8.8);
INSERT INTO SeniorCustomers VALUES (4, 'Amit Patel', 45, 9.2);
INSERT INTO SeniorCustomers VALUES (5, 'Suresh Reddy', 62, 10.5);


BEGIN
    FOR cust IN (
        SELECT CustomerID, Name, Age FROM SeniorCustomers WHERE Age > 60
    ) LOOP
        UPDATE SeniorCustomers
        SET InterestRate = InterestRate - 1
        WHERE CustomerID = cust.CustomerID;

        DBMS_OUTPUT.PUT_LINE('1% discount applied for: ' || cust.Name || ' (Customer ID: ' || cust.CustomerID || ')');
    END LOOP;
END;
/


SELECT * FROM SeniorCustomers;
