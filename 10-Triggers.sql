-- Step 1: Create the database and use it
CREATE DATABASE school_management;
USE school_management;

-- Step 2: Create the teachers table
CREATE TABLE teachers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    subject VARCHAR(50),
    experience INT,
    salary DECIMAL(10, 2)
);

-- Insert 8 rows into teachers table
INSERT INTO teachers VALUES
(1, 'Alice Johnson', 'Math', 12, 50000.00),
(2, 'Bob Smith', 'Physics', 8, 45000.00),
(3, 'Charlie Brown', 'Chemistry', 15, 60000.00),
(4, 'Diana Adams', 'Biology', 5, 40000.00),
(5, 'Eve Turner', 'English', 10, 48000.00),
(6, 'Frank White', 'History', 3, 38000.00),
(7, 'Grace Lee', 'Computer Science', 7, 55000.00),
(8, 'Henry Wilson', 'Art', 4, 36000.00);


-- Step 3: Create a before insert trigger to prevent negative salaries
DELIMITER $$
CREATE TRIGGER before_insert_teacher
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END$$
DELIMITER ;

-- Step 4: Create the teacher_log table
CREATE TABLE teacher_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT,
    action VARCHAR(50),
    timestamp DATETIME
);

-- Create an after insert trigger to log insert actions
DELIMITER $$
CREATE TRIGGER after_insert_teacher
AFTER INSERT ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (NEW.id, 'INSERT', NOW());
END$$
DELIMITER ;

-- Step 5: Create a before delete trigger to prevent deletion of experienced teachers
DELIMITER $$
CREATE TRIGGER before_delete_teacher
BEFORE DELETE ON teachers
FOR EACH ROW
BEGIN
    IF OLD.experience > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete teachers with experience greater than 10 years';
    END IF;
END$$
DELIMITER ;

-- Step 6: Create an after delete trigger to log delete actions
DELIMITER $$
CREATE TRIGGER after_delete_teacher
AFTER DELETE ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (OLD.id, 'DELETE', NOW());
END$$
DELIMITER ;
