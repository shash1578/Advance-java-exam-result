-- ============================================================
-- ONLINE EXAMINATION AND RESULT MANAGEMENT SYSTEM
-- Database: online_exam_system
-- Compatible with MySQL 8.x / MariaDB 10.4+
-- ============================================================

CREATE DATABASE IF NOT EXISTS online_exam_system
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE online_exam_system;

-- ------------------------------------------------------------
-- 1. Table: users
-- ------------------------------------------------------------
DROP TABLE IF EXISTS results;
DROP TABLE IF EXISTS student_answers;
DROP TABLE IF EXISTS exam_attempts;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'TEACHER', 'STUDENT') NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 2. Table: students
-- ------------------------------------------------------------
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    roll_number VARCHAR(50) NOT NULL UNIQUE,
    department VARCHAR(100) NOT NULL,
    admission_year INT NOT NULL,
    CONSTRAINT fk_students_user FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 3. Table: teachers
-- ------------------------------------------------------------
CREATE TABLE teachers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    employee_id VARCHAR(50) NOT NULL UNIQUE,
    department VARCHAR(100) NOT NULL,
    qualification VARCHAR(100),
    CONSTRAINT fk_teachers_user FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 4. Table: subjects
-- ------------------------------------------------------------
CREATE TABLE subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_code VARCHAR(20) NOT NULL UNIQUE,
    subject_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 5. Table: exams
-- ------------------------------------------------------------
CREATE TABLE exams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT NOT NULL,
    subject_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    instructions TEXT,
    duration_minutes INT NOT NULL DEFAULT 30,
    total_marks INT NOT NULL DEFAULT 100,
    passing_marks INT NOT NULL DEFAULT 40,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    allow_multiple_attempts BOOLEAN NOT NULL DEFAULT FALSE,
    negative_marking_per_question DECIMAL(4,2) NOT NULL DEFAULT 0.00,
    randomize_questions BOOLEAN NOT NULL DEFAULT FALSE,
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_exams_teacher FOREIGN KEY (teacher_id) 
        REFERENCES teachers(id) ON DELETE CASCADE,
    CONSTRAINT fk_exams_subject FOREIGN KEY (subject_id) 
        REFERENCES subjects(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 6. Table: questions
-- ------------------------------------------------------------
CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    question_text TEXT NOT NULL,
    option_a TEXT NOT NULL,
    option_b TEXT NOT NULL,
    option_c TEXT NOT NULL,
    option_d TEXT NOT NULL,
    correct_option ENUM('A', 'B', 'C', 'D') NOT NULL,
    marks INT NOT NULL DEFAULT 5,
    explanation TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_questions_exam FOREIGN KEY (exam_id) 
        REFERENCES exams(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 7. Table: exam_attempts
-- ------------------------------------------------------------
CREATE TABLE exam_attempts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    student_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    status ENUM('IN_PROGRESS', 'SUBMITTED', 'EXPIRED') NOT NULL DEFAULT 'IN_PROGRESS',
    total_score DECIMAL(6,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_attempts_exam FOREIGN KEY (exam_id) 
        REFERENCES exams(id) ON DELETE CASCADE,
    CONSTRAINT fk_attempts_student FOREIGN KEY (student_id) 
        REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 8. Table: student_answers
-- ------------------------------------------------------------
CREATE TABLE student_answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    attempt_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option ENUM('A', 'B', 'C', 'D') DEFAULT NULL,
    is_marked_for_review BOOLEAN NOT NULL DEFAULT FALSE,
    is_correct BOOLEAN DEFAULT NULL,
    marks_awarded DECIMAL(5,2) DEFAULT 0.00,
    saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_answers_attempt FOREIGN KEY (attempt_id) 
        REFERENCES exam_attempts(id) ON DELETE CASCADE,
    CONSTRAINT fk_answers_question FOREIGN KEY (question_id) 
        REFERENCES questions(id) ON DELETE CASCADE,
    UNIQUE KEY uq_attempt_question (attempt_id, question_id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 9. Table: results
-- ------------------------------------------------------------
CREATE TABLE results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    attempt_id INT NOT NULL UNIQUE,
    exam_id INT NOT NULL,
    student_id INT NOT NULL,
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL,
    incorrect_answers INT NOT NULL,
    unattempted INT NOT NULL,
    total_marks DECIMAL(6,2) NOT NULL,
    obtained_marks DECIMAL(6,2) NOT NULL,
    percentage DECIMAL(5,2) NOT NULL,
    grade VARCHAR(5) NOT NULL,
    status ENUM('PASS', 'FAIL') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_results_attempt FOREIGN KEY (attempt_id) 
        REFERENCES exam_attempts(id) ON DELETE CASCADE,
    CONSTRAINT fk_results_exam FOREIGN KEY (exam_id) 
        REFERENCES exams(id) ON DELETE CASCADE,
    CONSTRAINT fk_results_student FOREIGN KEY (student_id) 
        REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- INDEXES FOR PERFORMANCE
-- ------------------------------------------------------------
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_students_roll ON students(roll_number);
CREATE INDEX idx_exams_start_end ON exams(start_time, end_time);
CREATE INDEX idx_attempts_student_exam ON exam_attempts(student_id, exam_id);
CREATE INDEX idx_results_student ON results(student_id);
CREATE INDEX idx_results_exam ON results(exam_id);

-- ============================================================
-- SEED SAMPLE DATA
-- Password for all sample users:
-- admin: admin123
-- teachers: teacher123
-- students: student123
-- ============================================================

-- 1. Seed Users
INSERT INTO users (id, username, email, password_hash, role, full_name, phone, is_active) VALUES
(1, 'admin', 'admin@exam.com', '65536:cQvXGVHOlcnRijlEcSt2ew==:Uf1NWY3q/lQm1v1mtY/X5gW09sIPGLZi+EL3ZEvPbgg=', 'ADMIN', 'System Administrator', '+1-555-0100', TRUE),
(2, 'dr.sharma', 'sharma@exam.com', '65536:oQN6a5rGbi+iep32d87E7g==:/KWfyzbaMVbDUa4fQw5dXzy27T3b3zvKGJ0eTYjTw3g=', 'TEACHER', 'Dr. Rajesh Sharma', '+1-555-0101', TRUE),
(3, 'prof.patel', 'patel@exam.com', '65536:oQN6a5rGbi+iep32d87E7g==:/KWfyzbaMVbDUa4fQw5dXzy27T3b3zvKGJ0eTYjTw3g=', 'TEACHER', 'Prof. Anita Patel', '+1-555-0102', TRUE),
(4, 'dr.verma', 'verma@exam.com', '65536:oQN6a5rGbi+iep32d87E7g==:/KWfyzbaMVbDUa4fQw5dXzy27T3b3zvKGJ0eTYjTw3g=', 'TEACHER', 'Dr. Vikram Verma', '+1-555-0103', TRUE),
(5, 'rohit.kumar', 'rohit@exam.com', '65536:3gqn9opS9CWJ20PR67BVnQ==:5s0y4HuYFqhBOPrPrx2k11v2ahIK3nUggrHxFdZzr6k=', 'STUDENT', 'Rohit Kumar', '+1-555-0201', TRUE),
(6, 'priya.singh', 'priya@exam.com', '65536:3gqn9opS9CWJ20PR67BVnQ==:5s0y4HuYFqhBOPrPrx2k11v2ahIK3nUggrHxFdZzr6k=', 'STUDENT', 'Priya Singh', '+1-555-0202', TRUE),
(7, 'amit.gupta', 'amit@exam.com', '65536:3gqn9opS9CWJ20PR67BVnQ==:5s0y4HuYFqhBOPrPrx2k11v2ahIK3nUggrHxFdZzr6k=', 'STUDENT', 'Amit Gupta', '+1-555-0203', TRUE),
(8, 'sneha.reddy', 'sneha@exam.com', '65536:3gqn9opS9CWJ20PR67BVnQ==:5s0y4HuYFqhBOPrPrx2k11v2ahIK3nUggrHxFdZzr6k=', 'STUDENT', 'Sneha Reddy', '+1-555-0204', TRUE);

-- 2. Seed Teachers
INSERT INTO teachers (id, user_id, employee_id, department, qualification) VALUES
(1, 2, 'EMP-T101', 'Computer Science & Engineering', 'Ph.D. in Computer Science'),
(2, 3, 'EMP-T102', 'Information Technology', 'M.Tech in Software Engineering'),
(3, 4, 'EMP-T103', 'Computer Science & Engineering', 'Ph.D. in Information Systems');

-- 3. Seed Students
INSERT INTO students (id, user_id, roll_number, department, admission_year) VALUES
(1, 5, 'CS2024-001', 'Computer Science & Engineering', 2024),
(2, 6, 'CS2024-002', 'Computer Science & Engineering', 2024),
(3, 7, 'CS2024-003', 'Information Technology', 2024),
(4, 8, 'CS2024-004', 'Information Technology', 2024);

-- 4. Seed Subjects
INSERT INTO subjects (id, subject_code, subject_name, description) VALUES
(1, 'CS101', 'Advanced Java & Jakarta EE', 'Server-side enterprise Java development covering Servlets, JSP, JDBC, MVC architecture, and session management.'),
(2, 'CS102', 'Database Management Systems', 'Relational database modeling, SQL queries, normalization, transactions, ACID properties, and indexing.'),
(3, 'CS103', 'Data Structures & Algorithms', 'Fundamental algorithms, time complexity, trees, graphs, dynamic programming, and hash maps.'),
(4, 'CS104', 'Web Technologies & Frameworks', 'Modern front-end architecture, HTML5, CSS3, JavaScript ES6+, RESTful APIs, and responsive design.'),
(5, 'CS105', 'Software Engineering & Agile', 'Software development lifecycle, agile methodologies, design patterns, software testing, and architecture.');

-- 5. Seed Exams
INSERT INTO exams (id, teacher_id, subject_id, title, description, instructions, duration_minutes, total_marks, passing_marks, start_time, end_time, allow_multiple_attempts, negative_marking_per_question, randomize_questions, is_published) VALUES
(1, 1, 1, 'Jakarta Servlets & JDBC Major Exam', 
'Comprehensive assessment on Jakarta Servlets lifecycle, JDBC connectivity, PreparedStatement, session handling, and MVC patterns.',
'1. The examination consists of 5 multiple-choice questions.\n2. Total time allowed is 30 minutes.\n3. Each question carries 5 marks. No negative marking.\n4. You can navigate between questions using Previous and Next or the palette.\n5. You can mark questions for review and return to them later.\n6. The examination will automatically submit when the timer expires.\n7. Answers are saved dynamically as you select them.',
30, 25, 10, '2026-01-01 00:00:00', '2027-12-31 23:59:59', FALSE, 0.00, FALSE, TRUE),

(2, 2, 2, 'Relational Database & SQL Midterm Test', 
'Midterm quiz assessing SQL queries, joins, ACID transactions, normalization forms, and indexing mechanisms.',
'1. Total 5 questions, 20 marks total.\n2. Duration: 20 minutes.\n3. Passing marks: 8.\n4. Do not refresh or close browser tab during the test.\n5. Click Submit Examination once finished.',
20, 20, 8, '2026-01-01 00:00:00', '2027-12-31 23:59:59', TRUE, 1.00, FALSE, TRUE),

(3, 3, 3, 'Data Structures & Algorithmic Analysis Quiz',
'Evaluates mastery of Big-O complexity, binary search trees, graph traversals, and dynamic programming.',
'1. Duration: 25 minutes.\n2. Attempt all questions.\n3. Each question carries 5 marks.',
25, 25, 10, '2027-01-01 10:00:00', '2027-01-01 18:00:00', FALSE, 0.00, FALSE, TRUE);

-- 6. Seed Questions for Exam 1 (CS101 - Jakarta Servlets)
INSERT INTO questions (id, exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks, explanation) VALUES
(1, 1, 
'Which package in Apache Tomcat 10.1+ is used to import HttpServlet, HttpServletRequest, and HttpServletResponse?',
'javax.servlet.http.*',
'jakarta.servlet.http.*',
'org.apache.catalina.http.*',
'java.servlet.http.*',
'B', 5, 
'Starting with Jakarta EE 9 and Tomcat 10+, the package namespace migrated from javax.servlet to jakarta.servlet.'),

(2, 1, 
'Which method in the Servlet lifecycle is executed only ONCE during the entire lifecycle of the servlet instance?',
'service(HttpServletRequest, HttpServletResponse)',
'doGet(HttpServletRequest, HttpServletResponse)',
'init(ServletConfig)',
'destroy()',
'C', 5, 
'The init() method is invoked exactly once by the servlet container when loading and initializing the servlet.'),

(3, 1, 
'Why should PreparedStatement always be favored over Statement when executing parameterized database queries?',
'PreparedStatement is always faster than Statement in all scenarios.',
'PreparedStatement prevents SQL injection by pre-compiling queries and properly escaping parameter values.',
'PreparedStatement automatically closes the database connection.',
'Statement cannot execute SELECT queries with WHERE clauses.',
'B', 5, 
'PreparedStatement uses placeholders (?) and parameterized queries that protect against SQL injection vulnerabilities.'),

(4, 1, 
'Which method should be called on the HttpSession object to invalidate a user session upon logout?',
'session.destroy()',
'session.close()',
'session.invalidate()',
'session.removeAttribute("all")',
'C', 5, 
'Calling session.invalidate() invalidates the session and unbinds any objects bound to it.'),

(5, 1, 
'In the Model-View-Controller (MVC) architecture of a Java web application, which component typically acts as the Controller?',
'JavaServer Pages (JSP)',
'JavaBeans / POJO classes',
'Jakarta Servlet',
'MySQL Database Table',
'C', 5, 
'In Model 2 (MVC) web architecture, Servlets act as Controllers dispatching requests, POJOs/DAOs form the Model, and JSPs serve as Views.');

-- 7. Seed Questions for Exam 2 (CS102 - DBMS)
INSERT INTO questions (id, exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks, explanation) VALUES
(6, 2, 
'Which normal form removes partial dependency on a composite primary key?',
'First Normal Form (1NF)',
'Second Normal Form (2NF)',
'Third Normal Form (3NF)',
'Boyce-Codd Normal Form (BCNF)',
'B', 4, 
'2NF requires the table to be in 1NF and all non-key attributes must be fully functionally dependent on the entire primary key.'),

(7, 2, 
'What does the "I" stand for in the ACID properties of database transactions?',
'Integrity',
'Isolation',
'Iterability',
'Immutability',
'B', 4, 
'ACID stands for Atomicity, Consistency, Isolation, and Durability.'),

(8, 2, 
'Which SQL JOIN returns all rows from the left table and matched rows from the right table, filling nulls if no match is found?',
'INNER JOIN',
'RIGHT JOIN',
'LEFT JOIN',
'FULL OUTER JOIN',
'C', 4, 
'A LEFT JOIN (or LEFT OUTER JOIN) returns all records from the left table and matched records from the right table.'),

(9, 2, 
'Which index structure is the default and most widely utilized in MySQL InnoDB storage engine for B+tree searching?',
'Hash Index',
'B-Tree / B+Tree Index',
'R-Tree Index',
'Fulltext Index',
'B', 4, 
'InnoDB uses B+Tree structures for primary key clustering and secondary indexes for efficient range and point queries.'),

(10, 2, 
'Which statement correctly describes a database FOREIGN KEY constraint?',
'It uniquely identifies each record in its own table.',
'It enforces referential integrity between columns of two related tables.',
'It encrypts sensitive columns such as passwords.',
'It automatically creates a view across multiple tables.',
'B', 4, 
'A FOREIGN KEY constraint establishes a link between data in two tables and enforces referential integrity.');

-- 8. Seed Completed Attempt and Result for Student Rohit Kumar (CS2024-001) on Exam 1
INSERT INTO exam_attempts (id, exam_id, student_id, start_time, end_time, status, total_score) VALUES
(1, 1, 1, '2026-03-01 10:00:00', '2026-03-01 10:22:15', 'SUBMITTED', 25.00);

INSERT INTO student_answers (attempt_id, question_id, selected_option, is_marked_for_review, is_correct, marks_awarded) VALUES
(1, 1, 'B', FALSE, TRUE, 5.00),
(1, 2, 'C', FALSE, TRUE, 5.00),
(1, 3, 'B', FALSE, TRUE, 5.00),
(1, 4, 'C', FALSE, TRUE, 5.00),
(1, 5, 'C', FALSE, TRUE, 5.00);

INSERT INTO results (id, attempt_id, exam_id, student_id, total_questions, correct_answers, incorrect_answers, unattempted, total_marks, obtained_marks, percentage, grade, status) VALUES
(1, 1, 1, 1, 5, 5, 0, 0, 25.00, 25.00, 100.00, 'O', 'PASS');

-- 9. Seed Completed Attempt and Result for Student Priya Singh (CS2024-002) on Exam 1
INSERT INTO exam_attempts (id, exam_id, student_id, start_time, end_time, status, total_score) VALUES
(2, 1, 2, '2026-03-01 11:00:00', '2026-03-01 11:25:40', 'SUBMITTED', 20.00);

INSERT INTO student_answers (attempt_id, question_id, selected_option, is_marked_for_review, is_correct, marks_awarded) VALUES
(2, 1, 'B', FALSE, TRUE, 5.00),
(2, 2, 'C', FALSE, TRUE, 5.00),
(2, 3, 'B', FALSE, TRUE, 5.00),
(2, 4, 'A', FALSE, FALSE, 0.00),
(2, 5, 'C', FALSE, TRUE, 5.00);

INSERT INTO results (id, attempt_id, exam_id, student_id, total_questions, correct_answers, incorrect_answers, unattempted, total_marks, obtained_marks, percentage, grade, status) VALUES
(2, 2, 1, 2, 5, 4, 1, 0, 25.00, 20.00, 80.00, 'A+', 'PASS');
