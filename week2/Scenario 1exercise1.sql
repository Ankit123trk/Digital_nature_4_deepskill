use bank_system;
DELIMITER //

CREATE PROCEDURE ApplySeniorDiscountSimple()
BEGIN
    DECLARE v_customer_count INT;
    DECLARE v_counter INT DEFAULT 1;
    DECLARE v_customer_id INT;
    DECLARE v_age INT;
    DECLARE discounts_applied INT DEFAULT 0;
    
    -- Get total number of customers with active loans
    SELECT COUNT(DISTINCT c.customer_id) INTO v_customer_count
    FROM customers c
    INNER JOIN loans l ON c.customer_id = l.customer_id
    WHERE l.loan_status = 'ACTIVE';
    
    START TRANSACTION;
    
    -- Loop through customers
    WHILE v_counter <= v_customer_count DO
        -- Get customer info by row number
        SELECT c.customer_id, TIMESTAMPDIFF(YEAR, c.date_of_birth, CURDATE())
        INTO v_customer_id, v_age
        FROM (
            SELECT DISTINCT c.customer_id, c.date_of_birth,
                   ROW_NUMBER() OVER (ORDER BY c.customer_id) as row_num
            FROM customers c
            INNER JOIN loans l ON c.customer_id = l.customer_id
            WHERE l.loan_status = 'ACTIVE'
        ) numbered_customers
        WHERE row_num = v_counter;
        
        -- Apply discount for seniors
        IF v_age > 60 THEN
            UPDATE loans 
            SET interest_rate = GREATEST(interest_rate - 1.00, 0.50)
            WHERE customer_id = v_customer_id AND loan_status = 'ACTIVE';
            
            SET discounts_applied = discounts_applied + 1;
        END IF;
        
        SET v_counter = v_counter + 1;
    END WHILE;
    
    SELECT discounts_applied as 'Total Senior Discounts Applied';
    
    COMMIT;
END //

DELIMITER ;
call ApplySeniorDiscountSimple();