use bank_system;
DELIMITER //

CREATE PROCEDURE UpdateEmployeeBonus(
    IN p_department VARCHAR(50),
    IN p_bonus_percentage DECIMAL(5,2)
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_employee_id INT;
    DECLARE v_employee_name VARCHAR(100);
    DECLARE v_current_salary DECIMAL(10,2);
    DECLARE v_bonus_amount DECIMAL(10,2);
    DECLARE v_new_salary DECIMAL(10,2);
    DECLARE employees_updated INT DEFAULT 0;
    DECLARE total_bonus_paid DECIMAL(15,2) DEFAULT 0.00;
    DECLARE avg_bonus DECIMAL(10,2);
    
    -- Input validation
    DECLARE invalid_input CONDITION FOR SQLSTATE '45000';
    
    -- Cursor for employees in specified department
    DECLARE bonus_cursor CURSOR FOR 
        SELECT employee_id, employee_name, current_salary
        FROM employees
        WHERE department = p_department 
        AND status = 'ACTIVE'
        AND current_salary > 0;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Create temporary table for bonus processing log
    CREATE TEMPORARY TABLE IF NOT EXISTS bonus_log (
        log_id INT AUTO_INCREMENT PRIMARY KEY,
        employee_name VARCHAR(100),
        department VARCHAR(50),
        previous_salary DECIMAL(10,2),
        bonus_percentage DECIMAL(5,2),
        bonus_amount DECIMAL(10,2),
        new_salary DECIMAL(10,2),
        processing_date DATE DEFAULT (CURDATE())
    );
    
    -- Validate input parameters
    IF p_department IS NULL OR p_department = '' THEN
        SIGNAL invalid_input SET MESSAGE_TEXT = 'Department name cannot be empty';
    END IF;
    
    IF p_bonus_percentage IS NULL OR p_bonus_percentage < 0 OR p_bonus_percentage > 100 THEN
        SIGNAL invalid_input SET MESSAGE_TEXT = 'Bonus percentage must be between 0 and 100';
    END IF;
    
    START TRANSACTION;
    
    SELECT CONCAT('Processing bonus for department: ', p_department, 
                  ' with ', p_bonus_percentage, '% bonus') as process_info;
    
    -- Check if department exists
    IF NOT EXISTS (SELECT 1 FROM employees WHERE department = p_department AND status = 'ACTIVE') THEN
        SELECT CONCAT('No active employees found in department: ', p_department) as warning_message;
        ROLLBACK;
    ELSE
        
        OPEN bonus_cursor;
        
        -- Process each employee
        bonus_loop: LOOP
            FETCH bonus_cursor INTO v_employee_id, v_employee_name, v_current_salary;
            
            IF done THEN
                LEAVE bonus_loop;
            END IF;
            
            -- Calculate bonus amount
            SET v_bonus_amount = ROUND((v_current_salary * p_bonus_percentage / 100), 2);
            SET v_new_salary = v_current_salary + v_bonus_amount;
            
            -- Update employee salary
            UPDATE employees 
            SET current_salary = v_new_salary
            WHERE employee_id = v_employee_id;
            
            -- Log the bonus processing
            INSERT INTO bonus_log (employee_name, department, previous_salary, 
                                  bonus_percentage, bonus_amount, new_salary)
            VALUES (v_employee_name, p_department, v_current_salary, 
                    p_bonus_percentage, v_bonus_amount, v_new_salary);
            
            -- Update counters
            SET employees_updated = employees_updated + 1;
            SET total_bonus_paid = total_bonus_paid + v_bonus_amount;
            
        END LOOP;
        
        CLOSE bonus_cursor;
        
        -- Calculate average bonus
        IF employees_updated > 0 THEN
            SET avg_bonus = total_bonus_paid / employees_updated;
        ELSE
            SET avg_bonus = 0;
        END IF;
        
        -- Display detailed results
        SELECT 'EMPLOYEE BONUS PROCESSING REPORT' as report_title;
        
        SELECT employee_name as 'Employee Name',
               department as 'Department',
               CONCAT('$', FORMAT(previous_salary, 2)) as 'Previous Salary',
               CONCAT(bonus_percentage, '%') as 'Bonus %',
               CONCAT('$', FORMAT(bonus_amount, 2)) as 'Bonus Amount',
               CONCAT('$', FORMAT(new_salary, 2)) as 'New Salary',
               CONCAT('$', FORMAT(new_salary - previous_salary, 2)) as 'Salary Increase'
        FROM bonus_log
        ORDER BY bonus_amount DESC;
        
        -- Summary report
        SELECT p_department as 'Department',
               employees_updated as 'Employees Updated',
               CONCAT('$', FORMAT(total_bonus_paid, 2)) as 'Total Bonus Paid',
               CONCAT('$', FORMAT(avg_bonus, 2)) as 'Average Bonus per Employee',
               CONCAT(p_bonus_percentage, '%') as 'Bonus Percentage Applied';
        
        COMMIT;
        
    END IF;
    
    -- Clean up temporary table
    DROP TEMPORARY TABLE IF EXISTS bonus_log;
    
END //

DELIMITER ;

-- Execute the procedure with different departments
CALL UpdateEmployeeBonus('LENDING', 5.0);
CALL UpdateEmployeeBonus('IT', 7.5);
CALL UpdateEmployeeBonus('CUSTOMER_SERVICE', 3.0);