use bank_system;
DELIMITER //

CREATE PROCEDURE TransferFunds(
    IN p_from_account_number VARCHAR(20),
    IN p_to_account_number VARCHAR(20),
    IN p_amount DECIMAL(15,2),
    IN p_description TEXT
)
BEGIN
    DECLARE v_from_account_id INT;
    DECLARE v_to_account_id INT;
    DECLARE v_from_balance DECIMAL(15,2);
    DECLARE v_to_balance DECIMAL(15,2);
    DECLARE v_from_customer_name VARCHAR(100);
    DECLARE v_to_customer_name VARCHAR(100);
    DECLARE v_transfer_fee DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_description TEXT;
    
    -- Custom error conditions
    DECLARE insufficient_funds CONDITION FOR SQLSTATE '45001';
    DECLARE invalid_account CONDITION FOR SQLSTATE '45002';
    DECLARE invalid_amount CONDITION FOR SQLSTATE '45003';
    DECLARE same_account CONDITION FOR SQLSTATE '45004';
    
    -- Error handler for rollback
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
            @sqlstate = RETURNED_SQLSTATE, 
            @errno = MYSQL_ERRNO, 
            @text = MESSAGE_TEXT;
        
        -- Log failed transaction
        INSERT INTO transaction_history (from_account_id, to_account_id, transaction_type, 
                                       amount, description, status)
        VALUES (v_from_account_id, v_to_account_id, 'TRANSFER', p_amount, 
                CONCAT('FAILED: ', @text), 'FAILED');
        
        SELECT CONCAT('Transfer failed: ', @text) as error_message;
    END;
    
    -- Input validation
    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL invalid_amount SET MESSAGE_TEXT = 'Transfer amount must be greater than 0';
    END IF;
    
    IF p_from_account_number IS NULL OR p_to_account_number IS NULL THEN
        SIGNAL invalid_account SET MESSAGE_TEXT = 'Account numbers cannot be null';
    END IF;
    
    IF p_from_account_number = p_to_account_number THEN
        SIGNAL same_account SET MESSAGE_TEXT = 'Cannot transfer to the same account';
    END IF;
    
    -- Set description
    IF p_description IS NULL THEN
        SET v_description = CONCAT('Fund transfer from ', p_from_account_number, 
                                  ' to ', p_to_account_number);
    ELSE
        SET v_description = p_description;
    END IF;
    
    START TRANSACTION;
    
    -- Get source account details with row lock
    SELECT a.account_id, a.balance, c.customer_name
    INTO v_from_account_id, v_from_balance, v_from_customer_name
    FROM accounts a
    INNER JOIN customers c ON a.customer_id = c.customer_id
    WHERE a.account_number = p_from_account_number 
    AND a.status = 'ACTIVE'
    FOR UPDATE;
    
    -- Check if source account exists
    IF v_from_account_id IS NULL THEN
        SIGNAL invalid_account SET MESSAGE_TEXT = 'Source account not found or inactive';
    END IF;
    
    -- Get destination account details with row lock
    SELECT a.account_id, a.balance, c.customer_name
    INTO v_to_account_id, v_to_balance, v_to_customer_name
    FROM accounts a
    INNER JOIN customers c ON a.customer_id = c.customer_id
    WHERE a.account_number = p_to_account_number 
    AND a.status = 'ACTIVE'
    FOR UPDATE;
    
    -- Check if destination account exists
    IF v_to_account_id IS NULL THEN
        SIGNAL invalid_account SET MESSAGE_TEXT = 'Destination account not found or inactive';
    END IF;
    
    -- Calculate transfer fee (0.1% for transfers over $10,000)
    IF p_amount > 10000 THEN
        SET v_transfer_fee = ROUND(p_amount * 0.001, 2);
    END IF;
    
    -- Check sufficient balance (including transfer fee)
    IF v_from_balance < (p_amount + v_transfer_fee) THEN
       SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 
            CONCAT('Insufficient funds. Available: $', FORMAT(v_from_balance, 2), 
                   ', Required: $', FORMAT(p_amount + v_transfer_fee, 2));
    END IF;
    
    -- Perform the transfer
    -- Debit from source account
    UPDATE accounts 
    SET balance = balance - p_amount - v_transfer_fee
    WHERE account_id = v_from_account_id;
    
    -- Credit to destination account
    UPDATE accounts 
    SET balance = balance + p_amount
    WHERE account_id = v_to_account_id;
    
    -- Record the transfer transaction
    INSERT INTO transaction_history (from_account_id, to_account_id, transaction_type, 
                                   amount, description, status)
    VALUES (v_from_account_id, v_to_account_id, 'TRANSFER', p_amount, v_description, 'COMPLETED');
    
    -- Record transfer fee if applicable
    IF v_transfer_fee > 0 THEN
        INSERT INTO transaction_history (from_account_id, transaction_type, 
                                       amount, description, status)
        VALUES (v_from_account_id, 'WITHDRAWAL', v_transfer_fee, 
                'Transfer fee', 'COMPLETED');
    END IF;
    
    -- Display transfer confirmation
    SELECT 'FUND TRANSFER COMPLETED' as status;
    
    SELECT 
        p_from_account_number as 'From Account',
        v_from_customer_name as 'From Customer',
        p_to_account_number as 'To Account',
        v_to_customer_name as 'To Customer',
        CONCAT('$', FORMAT(p_amount, 2)) as 'Transfer Amount',
        CONCAT('$', FORMAT(v_transfer_fee, 2)) as 'Transfer Fee',
        CONCAT('$', FORMAT(p_amount + v_transfer_fee, 2)) as 'Total Debited',
        CURRENT_TIMESTAMP as 'Transfer Time';
    
    -- Show updated balances
    SELECT 
        p_from_account_number as 'Account Number',
        v_from_customer_name as 'Customer Name',
        CONCAT('$', FORMAT(v_from_balance, 2)) as 'Previous Balance',
        CONCAT('$', FORMAT(v_from_balance - p_amount - v_transfer_fee, 2)) as 'New Balance'
    UNION ALL
    SELECT 
        p_to_account_number as 'Account Number',
        v_to_customer_name as 'Customer Name',
        CONCAT('$', FORMAT(v_to_balance, 2)) as 'Previous Balance',
        CONCAT('$', FORMAT(v_to_balance + p_amount, 2)) as 'New Balance';
    
    COMMIT;
    
END //

DELIMITER ;

-- Test the transfer procedure
CALL TransferFunds('SAV001', 'SAV002', 1000.00, 'Monthly transfer');
CALL TransferFunds('SAV003', 'CHK003', 5000.00, 'Internal account transfer');
-- To call without description, pass NULL explicitly
CALL TransferFunds('SAV001', 'CHK001', 500.00, NULL);