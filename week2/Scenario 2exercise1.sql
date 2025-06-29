use bank_system;
DELIMITER //

CREATE PROCEDURE AssignVIPStatusWithCase()
BEGIN
    DECLARE customers_updated INT;
    
    START TRANSACTION;
    
    -- Update all customers at once using CASE
    UPDATE customers 
    SET is_vip = CASE 
        WHEN balance > 10000.00 THEN TRUE 
        ELSE FALSE 
    END;
    
    -- Get count of affected rows
    GET DIAGNOSTICS customers_updated = ROW_COUNT;
    
    -- Display results
    SELECT customers_updated as 'Total Customers Updated',
           COUNT(*) as 'New VIP Customers'
    FROM customers 
    WHERE is_vip = TRUE;
    
    COMMIT;
END //

DELIMITER ;
call AssignVIPStatusWithCase();