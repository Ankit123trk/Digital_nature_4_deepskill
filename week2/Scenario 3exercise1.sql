use bank_system;
DELIMITER //

CREATE PROCEDURE SendLoanReminders()
BEGIN
    DECLARE v_loan_count INT;
    DECLARE v_counter INT DEFAULT 1;
    DECLARE v_customer_name VARCHAR(100);
    DECLARE v_loan_amount DECIMAL(15,2);
    DECLARE v_due_date DATE;
    DECLARE v_days_until_due INT;
    
    -- Get count of loans due in next 30 days
    SELECT COUNT(*) INTO v_loan_count
    FROM loans l
    INNER JOIN customers c ON l.customer_id = c.customer_id
    WHERE l.loan_status = 'ACTIVE'
    AND l.due_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);
    
    -- Process each loan
    WHILE v_counter <= v_loan_count DO
        -- Get loan details by row number
        SELECT customer_name, loan_amount, due_date, days_until_due
        INTO v_customer_name, v_loan_amount, v_due_date, v_days_until_due
        FROM (
            SELECT c.customer_name, l.loan_amount, l.due_date,
                   DATEDIFF(l.due_date, CURDATE()) as days_until_due,
                   ROW_NUMBER() OVER (ORDER BY l.due_date) as row_num
            FROM loans l
            INNER JOIN customers c ON l.customer_id = c.customer_id
            WHERE l.loan_status = 'ACTIVE'
            AND l.due_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
        ) numbered_loans
        WHERE row_num = v_counter;
        
        -- Print reminder message
        SELECT CONCAT('REMINDER for ', v_customer_name, ': Loan of $', 
                     FORMAT(v_loan_amount, 2), ' due on ', v_due_date, 
                     ' (', v_days_until_due, ' days remaining)') as loan_reminder;
        
        SET v_counter = v_counter + 1;
    END WHILE;
    
    SELECT v_loan_count as 'Total Reminders Sent';
    
END //

DELIMITER ;

call SendLoanReminders();