use bank_system;
DELIMITER //

CREATE PROCEDURE ProcessMonthlyInterest()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_account_id INT;
    DECLARE v_account_number VARCHAR(20);
    DECLARE v_customer_name VARCHAR(100);
    DECLARE v_current_balance DECIMAL(15,2);
    DECLARE v_interest_rate DECIMAL(5,2);
    DECLARE v_interest_amount DECIMAL(15,2);
    DECLARE v_new_balance DECIMAL(15,2);
    DECLARE accounts_processed INT DEFAULT 0;
    DECLARE total_interest_paid DECIMAL(15,2) DEFAULT 0.00;
    DECLARE processing_date DATE DEFAULT CURDATE();
    
    -- Cursor for all active savings accounts
    DECLARE interest_cursor CURSOR FOR 
        SELECT a.account_id, a.account_number, c.customer_name, 
               a.balance, a.interest_rate
        FROM accounts a
        INNER JOIN customers c ON a.customer_id = c.customer_id
        WHERE a.account_type = 'SAVINGS' 
        AND a.status = 'ACTIVE'
        AND a.balance > 0;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Create temporary table for interest processing log
    CREATE TEMPORARY TABLE IF NOT EXISTS interest_log (
        log_id INT AUTO_INCREMENT PRIMARY KEY,
        account_number VARCHAR(20),
        customer_name VARCHAR(100),
        previous_balance DECIMAL(15,2),
        interest_rate DECIMAL(5,2),
        interest_amount DECIMAL(15,2),
        new_balance DECIMAL(15,2),
        processing_date DATE
    );
    
    START TRANSACTION;
    
    SELECT CONCAT('Starting Monthly Interest Processing for: ', processing_date) as process_start;
    
    OPEN interest_cursor;
    
    -- Process each savings account
    interest_loop: LOOP
        FETCH interest_cursor INTO v_account_id, v_account_number, v_customer_name, 
                                   v_current_balance, v_interest_rate;
        
        IF done THEN
            LEAVE interest_loop;
        END IF;
        
        -- Calculate monthly interest (annual rate / 12)
        SET v_interest_amount = ROUND((v_current_balance * v_interest_rate / 100) / 12, 2);
        SET v_new_balance = v_current_balance + v_interest_amount;
        
        -- Update account balance
        UPDATE accounts 
        SET balance = v_new_balance,
            last_interest_date = processing_date
        WHERE account_id = v_account_id;
        
        -- Log the transaction
        INSERT INTO transaction_history (to_account_id, transaction_type, amount, description)
        VALUES (v_account_id, 'INTEREST', v_interest_amount, 
                CONCAT('Monthly interest payment for ', processing_date));
        
        -- Add to processing log
        INSERT INTO interest_log (account_number, customer_name, previous_balance, 
                                 interest_rate, interest_amount, new_balance, processing_date)
        VALUES (v_account_number, v_customer_name, v_current_balance, 
                v_interest_rate, v_interest_amount, v_new_balance, processing_date);
        
        -- Update counters
        SET accounts_processed = accounts_processed + 1;
        SET total_interest_paid = total_interest_paid + v_interest_amount;
        
    END LOOP;
    
    CLOSE interest_cursor;
    
    -- Display processing results
    SELECT 'MONTHLY INTEREST PROCESSING REPORT' as report_title;
    
    SELECT account_number as 'Account Number',
           customer_name as 'Customer Name',
           CONCAT('$', FORMAT(previous_balance, 2)) as 'Previous Balance',
           CONCAT(interest_rate, '%') as 'Interest Rate',
           CONCAT('$', FORMAT(interest_amount, 2)) as 'Interest Earned',
           CONCAT('$', FORMAT(new_balance, 2)) as 'New Balance'
    FROM interest_log
    ORDER BY interest_amount DESC;
    
    -- Summary report
    SELECT accounts_processed as 'Total Accounts Processed',
           CONCAT('$', FORMAT(total_interest_paid, 2)) as 'Total Interest Paid',
           processing_date as 'Processing Date';
    
    COMMIT;
    
    -- Clean up temporary table
    DROP TEMPORARY TABLE interest_log;
    
END //

DELIMITER ;

-- Execute the procedure
CALL ProcessMonthlyInterest();