CREATE DATABASE bank_system;
use bank_system;
CREATE TABLE  customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    is_vip BOOLEAN DEFAULT FALSE,
    created_date DATE DEFAULT (CURRENT_DATE)
);
CREATE TABLE  loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    loan_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    due_date DATE NOT NULL,
    loan_status VARCHAR(20) DEFAULT 'ACTIVE',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO customers (customer_name, date_of_birth, balance) VALUES
('Ankit Kumar', '1955-03-15', 15000.00),
('Aditya Rajankar', '1990-07-22', 8500.00),
('Vinay Muraskar', '1948-11-30', 25000.00),
('Yugandhara Jagtap', '1962-05-10', 12000.00),
('Tayyaba Seikh', '1985-09-18', 5000.00),
('Khushi Atara', '1940-12-05', 30000.00);

INSERT INTO loans (customer_id, loan_amount, interest_rate, due_date) VALUES
(1, 50000.00, 6.50, '2025-07-15'),
(2, 25000.00, 7.25, '2025-08-20'),
(3, 75000.00, 5.75, '2025-07-10'),
(4, 40000.00, 6.00, '2025-07-25'),
(5, 15000.00, 8.00, '2025-09-30'),
(6, 60000.00, 5.50, '2025-07-05');