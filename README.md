# Online Examination and Result Management System

An enterprise-grade, database-driven web application built with **Java 21, Jakarta Servlets 6.0, JSP 3.1, JDBC, and MySQL**, designed to run on **Apache Tomcat 10.1+**.

---

## 1. System Overview

The **Online Examination and Result Management System** is a major college-level software engineering project designed to conduct, monitor, and evaluate academic assessments securely online.

### Core Highlights:
- **Role-Based Access Control (RBAC):** Distinct dashboards and access rules for **Administrator**, **Teacher**, and **Student**.
- **Interactive Examination Engine:**
  - Single-question focused view with 4 option cards.
  - Interactive **Question Palette** (Green: Answered, Amber: Marked for Review, Gray: Unanswered, Blue halo: Current).
  - **Zero-Loss Live Auto-Save:** Student selections are persisted to MySQL via background AJAX as they click.
  - **Server-Side Timer Enforcement:** Prevents client-side clock tampering; automatically finalizes and grades the exam upon expiry.
  - Single/Multiple Attempt enforcement according to teacher policy.
- **Automated Result Evaluation:**
  - Automatic answer comparison against server keys.
  - Negative marking deduction support.
  - Academic letter grades (`O`, `A+`, `A`, `B+`, `B`, `C`, `F`) and percentage calculation.
  - Question-by-question review with explanations (never exposed prior to submission).
  - Official printable & downloadable PDF marksheet with university insignia and signature seals.
  - Result export to CSV for institutional archives.

---

## 2. Technology Stack

| Component | Technology | Version |
| :--- | :--- | :--- |
| **Language** | Java | 21 (LTS) |
| **Server Engine** | Jakarta Servlet API | 6.0.0 (Tomcat 10.1+) |
| **View Engine** | JavaServer Pages (JSP) &amp; JSTL | 3.1.1 / JSTL 3.0.1 |
| **Database** | MySQL / MariaDB (via JDBC) | 8.x / 10.4+ |
| **Persistence** | JDBC `PreparedStatement` &amp; Transactions | Native |
| **JSON Interchange**| Google Gson | 2.10.1 |
| **Password Security**| Cryptographic PBKDF2WithHmacSHA256 | 65,536 iterations + random salt |
| **Frontend** | HTML5, CSS3, JavaScript ES6+, Bootstrap 5 | 5.3.3 &amp; Bootstrap Icons |
| **Charts** | Chart.js | 4.4.1 |
| **Build Tool** | Apache Maven | 3.x (`pom.xml`) |

---

## 3. Pre-Seeded User Accounts

All sample users are pre-configured in `database/schema.sql` with salted PBKDF2 hashes:

| Role | Username | Email | Password | Identifier / Department |
| :--- | :--- | :--- | :--- | :--- |
| **Administrator** | `admin` | `admin@exam.com` | `admin123` | Institutional Admin |
| **Teacher (Faculty)** | `dr.sharma` | `sharma@exam.com` | `teacher123` | EMP-T101 (Computer Science) |
| **Teacher (Faculty)** | `prof.patel` | `patel@exam.com` | `teacher123` | EMP-T102 (Information Tech) |
| **Student** | `rohit.kumar` | `rohit@exam.com` | `student123` | Roll: `CS2024-001` (CSE) |
| **Student** | `priya.singh` | `priya@exam.com` | `student123` | Roll: `CS2024-002` (CSE) |
| **Student** | `amit.gupta` | `amit@exam.com` | `student123` | Roll: `CS2024-003` (IT) |

*Note: On the login page (`/login`), click the 1-click **Quick Demo Autofill** pill badges to automatically fill any role's credentials!*

---

## 4. Database Setup Instructions

The application requires a MySQL database named `online_exam_system`.

### Step 1: Start MySQL Server
If using **XAMPP**, open **XAMPP Control Panel** and click **Start** next to **MySQL**.

### Step 2: Import Database Schema and Seed Data
Execute the provided SQL script (`database/schema.sql`) using any of the following methods:

#### Method A: Using MySQL Command Line Client
```bash
mysql -u root -p < "c:/Users/Shashank/adv_java-mcp/database/schema.sql"
```
*(If default XAMPP root password is empty, press Enter when prompted for password).*

#### Method B: Using phpMyAdmin
1. Open browser at `http://localhost/phpmyadmin/`.
2. Click on the **Import** tab in the top navigation.
3. Browse and select `database/schema.sql` from the project directory.
4. Click **Import** at the bottom.

### Step 3: Verify Database Connection Configuration
Check `src/main/resources/database.properties` (or `WEB-INF/classes/database.properties` in Tomcat):
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/online_exam_system?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.username=root
db.password=
```
*(Adjust `db.username` and `db.password` if your local MySQL installation has a custom password).*

---

## 5. Deployment on Apache Tomcat 10.1

### Option 1: Instant WAR Deployment (Recommended)
A pre-compiled, self-contained deployment package `target/online-exam-system.war` is already built.

1. Locate your Tomcat 10.1 installation directory (e.g., `C:\apache-tomcat-10.1.x` or `C:\xampp\tomcat`).
2. Copy `target/online-exam-system.war` into Tomcat's `webapps/` directory:
   ```powershell
   Copy-Item "c:\Users\Shashank\adv_java-mcp\target\online-exam-system.war" "C:\apache-tomcat-10.1.x\webapps\"
   ```
3. Start Apache Tomcat:
   ```powershell
   cd "C:\apache-tomcat-10.1.x\bin"
   .\startup.bat
   ```
4. Open your browser and navigate to:
   ```
   http://localhost:8080/online-exam-system/
   ```

---

### Option 2: Building with Maven
If you have Maven installed in your system PATH:
```bash
# Clean, compile, and package the WAR file
mvn clean package

# The generated war will be at target/online-exam-system.war
```

---

## 6. Project Architecture & Directory Layout

The project adheres strictly to the **MVC (Model-View-Controller)** pattern and **DAO (Data Access Object)** pattern:

```
adv_java-mcp/
├── pom.xml                                   # Maven build descriptor
├── README.md                                 # Documentation & installation guide
├── database/
│   └── schema.sql                            # Complete normalized DDL schema & sample seeds
├── lib/                                      # Downloaded Jakarta EE & MySQL driver JARs
├── target/
│   └── online-exam-system.war                # Packaged web application archive
└── src/main/
    ├── java/com/exam/
    │   ├── model/                            # Data Model POJOs
    │   │   ├── User.java                     # User credentials & Role (ADMIN, TEACHER, STUDENT)
    │   │   ├── Student.java                  # Roll number, department, batch
    │   │   ├── Teacher.java                  # Employee ID, department, qualification
    │   │   ├── Subject.java                  # Course catalog
    │   │   ├── Exam.java                     # Title, duration, total & passing marks, dates
    │   │   ├── Question.java                 # MCQ statement, options A-D, answer, marks
    │   │   ├── ExamAttempt.java              # Student attempt tracking & start/end times
    │   │   ├── StudentAnswer.java            # Saved option, review flag, marks awarded
    │   │   ├── Result.java                   # Score, %, grade, pass/fail status
    │   │   ├── DashboardStats.java           # Aggregated analytics for role dashboards
    │   │   └── StudentPerformance.java       # Individual student trend analytics
    │   ├── dao/                              # Data Access Layer with JDBC PreparedStatements
    │   │   ├── UserDAO.java
    │   │   ├── StudentDAO.java
    │   │   ├── TeacherDAO.java
    │   │   ├── SubjectDAO.java
    │   │   ├── ExamDAO.java
    │   │   ├── QuestionDAO.java
    │   │   ├── ExamAttemptDAO.java
    │   │   ├── ResultDAO.java
    │   │   └── DashboardDAO.java
    │   ├── util/                             # Utilities
    │   │   ├── DBConnection.java             # Thread-safe JDBC connection manager
    │   │   ├── PasswordUtil.java             # PBKDF2-HMAC-SHA256 password hasher
    │   │   ├── DateUtil.java                 # Timer and schedule calculator
    │   │   ├── GradeUtil.java                # Academic grading scale calculator
    │   │   └── CSVExportUtil.java            # Results CSV stream exporter
    │   ├── filter/                           # Security & Character Encoding Filters
    │   │   ├── AuthenticationFilter.java     # RBAC protection (/admin/*, /teacher/*, /student/*)
    │   │   └── EncodingFilter.java           # UTF-8 character encoding filter
    │   └── controller/                       # Jakarta Servlets (Controllers)
    │       ├── auth/                         # LoginServlet, LogoutServlet, RegisterServlet, ProfileServlet
    │       ├── admin/                        # Dashboard, Students, Teachers, Subjects, Exams, Results, Performance
    │       ├── teacher/                      # Dashboard, Exams, Questions, Attempts, Results, Review, CSV Export
    │       └── student/                      # Dashboard, Exams, Instructions, Start, ExamEngine, SaveAnswer, Submit, Results, Marksheet
    ├── resources/
    │   ├── database.properties               # DB connection configuration
    │   └── schema.sql
    └── webapp/                               # Frontend Views & Assets
        ├── assets/
        │   ├── css/custom.css                # Modern SaaS theme & exam engine styles
        │   └── js/
        │       ├── app.js                    # Table filters, toasts, modal helpers
        │       └── exam-engine.js            # Timer, AJAX autosave, palette navigation
        ├── includes/                         # Header, footer, and role sidebars
        ├── index.jsp                         # Landing page with demo shortcuts
        ├── login.jsp                         # Modern login card
        ├── register.jsp                      # Student registration
        ├── profile.jsp                       # Profile and password update
        ├── error.jsp                         # Custom 403, 404, 500 handler
        ├── admin/                            # Administrator views
        ├── teacher/                          # Instructor management views
        ├── student/                          # Student examination views
        └── WEB-INF/
            ├── web.xml                       # Deployment descriptor (Servlet 6.0)
            ├── classes/                      # Compiled class files & resources
            └── lib/                          # Bundled runtime JARs
```

---

## 7. Security & Business Logic Highlights

1. **Password Security:** Passwords are never stored in plaintext. They are hashed using **PBKDF2WithHmacSHA256** with 65,536 iterations and a cryptographically secure 16-byte random salt. Verification is performed in constant time to prevent timing attacks.
2. **SQL Injection Defense:** 100% of queries use `java.sql.PreparedStatement` with parameterized placeholders (`?`).
3. **Role-Based Authorization:** `AuthenticationFilter` intercepts every request, validates the active session, and redirects unauthorized users away from restricted paths (`/admin/*`, `/teacher/*`, `/student/*`).
4. **Server-Side Examination Timer:**
   - When an attempt starts, `start_time = NOW()` is stored in MySQL.
   - On every request and autosave, the server verifies `(start_time + durationMinutes) >= currentTime`.
   - If time has expired, the server automatically invokes the evaluation engine and marks the attempt as submitted.
5. **Zero Answers Exposed Prior to Submission:**
   - Students taking an exam receive a sanitized model where `correctOption` and `explanation` are `null`.
   - The correct answers are only loaded on the server during grading.
6. **Automatic Evaluation & Grading Scale:**
   - 90% - 100%: **O** (Outstanding)
   - 80% - 89.99%: **A+** (Excellent)
   - 70% - 79.99%: **A** (Very Good)
   - 60% - 69.99%: **B+** (Good)
   - 50% - 59.99%: **B** (Above Average)
   - 40% - 49.99%: **C** (Pass)
   - Below 40%: **F** (Fail)

---

## 8. Verification and Testing Checklist

- [x] Compilation without errors with JDK 21+
- [x] Database schema creation with normalized tables and foreign key constraints
- [x] Admin login, statistics, student/teacher/subject management
- [x] Teacher exam creation with duration, marks, options, and MCQ questions
- [x] Student registration, login, instruction view, and exam start
- [x] Online exam engine with live countdown timer, option highlight, and question palette
- [x] Asynchronous AJAX progress auto-save on option selection
- [x] Automatic grading, score calculation, and result storage in MySQL
- [x] Detailed question-by-question review with explanations
- [x] Official printable & downloadable PDF marksheet
- [x] Result export to CSV
- [x] Tomcat 10.1 deployment package (`online-exam-system.war`)
