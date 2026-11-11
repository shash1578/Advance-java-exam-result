<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Online Examination & Result Management System" />
<jsp:include page="/includes/header.jsp" />

<style>
    .hero-section {
        background: radial-gradient(circle at 50% 30%, #1e293b 0%, #0f172a 100%);
        color: white;
        padding: 5rem 1rem 6rem;
        text-align: center;
        position: relative;
        overflow: hidden;
    }
    .hero-badge {
        background-color: rgba(37, 99, 235, 0.2);
        color: #93c5fd;
        border: 1px solid rgba(147, 197, 253, 0.3);
        padding: 0.35rem 1rem;
        border-radius: 9999px;
        font-size: 0.85rem;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        margin-bottom: 1.5rem;
    }
    .hero-title {
        font-size: 3rem;
        font-weight: 800;
        letter-spacing: -0.02em;
        line-height: 1.2;
        margin-bottom: 1.25rem;
        background: linear-gradient(180deg, #ffffff 0%, #94a3b8 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }
    .hero-desc {
        font-size: 1.15rem;
        color: #94a3b8;
        max-width: 720px;
        margin: 0 auto 2.5rem;
        line-height: 1.6;
    }
    .role-card {
        background: white;
        border-radius: 12px;
        border: 1px solid #e2e8f0;
        padding: 2rem;
        height: 100%;
        transition: transform 0.2s, box-shadow 0.2s;
        display: flex;
        flex-direction: column;
    }
    .role-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 24px -6px rgba(0, 0, 0, 0.08);
    }
    .role-icon {
        width: 56px;
        height: 56px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.75rem;
        margin-bottom: 1.25rem;
    }
    .credential-box {
        background-color: #f8fafc;
        border-radius: 8px;
        padding: 0.85rem;
        font-size: 0.82rem;
        font-family: monospace;
        margin-top: auto;
        border: 1px dashed #cbd5e1;
    }
</style>

<!-- Public Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark py-3 px-4" style="background-color: #0f172a !important;">
    <div class="container">
        <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
            <i class="bi bi-mortarboard-fill text-primary" style="font-size: 1.5rem;"></i>
            <span>ExamPortal Pro</span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary-custom">
                        <i class="bi bi-speedometer2"></i> Go to Dashboard
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light px-3 py-2 fw-semibold">
                        Sign In
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary-custom">
                        Student Registration
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<header class="hero-section">
    <div class="container">
        <div class="hero-badge">
            <i class="bi bi-shield-check"></i> Enterprise Academic Examination Engine
        </div>
        <h1 class="hero-title">Online Examination &amp; Result Management System</h1>
        <p class="hero-desc">
            A comprehensive, database-driven assessment platform engineered for universities and colleges.
            Features role-based access control, real-time AJAX auto-saving examination engine, server-side timer validation, and automated grading with marksheet generation.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg px-4 py-3 fw-bold rounded-3 shadow">
                <i class="bi bi-box-arrow-in-right me-2"></i> Access Examination Portal
            </a>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light btn-lg px-4 py-3 fw-bold rounded-3">
                <i class="bi bi-person-plus me-2"></i> Register as Student
            </a>
        </div>
    </div>
</header>

<!-- Role Portals & Demo Accounts -->
<section class="py-5 bg-light">
    <div class="container py-4">
        <div class="text-center mb-5">
            <span class="text-primary fw-bold text-uppercase" style="font-size: 0.85rem; letter-spacing: 0.08em;">Role-Based Architecture</span>
            <h2 class="fw-bold mt-1">Dedicated Workspaces for Every User</h2>
            <p class="text-muted">Explore the functional features built specifically for Administrators, Teachers, and Students.</p>
        </div>

        <div class="row g-4">
            <!-- Admin Card -->
            <div class="col-md-4">
                <div class="role-card">
                    <div class="role-icon bg-danger-subtle text-danger">
                        <i class="bi bi-shield-lock-fill"></i>
                    </div>
                    <h3 class="fw-bold fs-4 mb-2">Administrator</h3>
                    <p class="text-muted fs-6 mb-4">
                        Oversee institutional operations, monitor examination metrics, manage student and teacher accounts, curate academic subjects, and review student performance analytics.
                    </p>
                    <div class="credential-box mb-3">
                        <div class="fw-bold text-dark mb-1">Demo Credentials:</div>
                        <div>Username: <code>admin</code></div>
                        <div>Password: <code>admin123</code></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/login?role=admin" class="btn btn-outline-danger w-100 fw-semibold">
                        Admin Login <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <!-- Teacher Card -->
            <div class="col-md-4">
                <div class="role-card">
                    <div class="role-icon bg-primary-subtle text-primary">
                        <i class="bi bi-person-badge-fill"></i>
                    </div>
                    <h3 class="fw-bold fs-4 mb-2">Faculty / Teacher</h3>
                    <p class="text-muted fs-6 mb-4">
                        Design and manage online examinations, author MCQ questions with options and explanations, monitor live student attempts, review individual answer sheets, and export results to CSV.
                    </p>
                    <div class="credential-box mb-3">
                        <div class="fw-bold text-dark mb-1">Demo Credentials:</div>
                        <div>Username: <code>dr.sharma</code></div>
                        <div>Password: <code>teacher123</code></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/login?role=teacher" class="btn btn-outline-primary w-100 fw-semibold">
                        Teacher Login <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <!-- Student Card -->
            <div class="col-md-4">
                <div class="role-card">
                    <div class="role-icon bg-success-subtle text-success">
                        <i class="bi bi-mortarboard-fill"></i>
                    </div>
                    <h3 class="fw-bold fs-4 mb-2">Student</h3>
                    <p class="text-muted fs-6 mb-4">
                        Browse active and upcoming examinations, read exam rules, attempt timed MCQ questions with palette navigation &amp; autosave, view instant scorecard results, and download official marksheets.
                    </p>
                    <div class="credential-box mb-3">
                        <div class="fw-bold text-dark mb-1">Demo Credentials:</div>
                        <div>Username: <code>rohit.kumar</code></div>
                        <div>Password: <code>student123</code></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/login?role=student" class="btn btn-outline-success w-100 fw-semibold">
                        Student Login <i class="bi bi-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- System Highlights -->
<section class="py-5 bg-white border-top">
    <div class="container py-4">
        <div class="row align-items-center g-5">
            <div class="col-lg-6">
                <span class="badge bg-primary-subtle text-primary mb-2 px-3 py-2 fs-6">Enterprise Features</span>
                <h2 class="fw-bold fs-2 mb-3">Advanced Online Examination Engine</h2>
                <ul class="list-unstyled d-flex flex-column gap-3 text-secondary mt-4">
                    <li class="d-flex align-items-start gap-3">
                        <i class="bi bi-check-circle-fill text-success fs-5"></i>
                        <div><strong>Zero-Loss Auto-Save:</strong> Responses are saved to MySQL via background AJAX as students click, preventing loss of progress on refresh.</div>
                    </li>
                    <li class="d-flex align-items-start gap-3">
                        <i class="bi bi-check-circle-fill text-success fs-5"></i>
                        <div><strong>Server-Side Timer Enforcement:</strong> Tamper-resistant exam timer calculated and validated strictly on the server against start timestamp.</div>
                    </li>
                    <li class="d-flex align-items-start gap-3">
                        <i class="bi bi-check-circle-fill text-success fs-5"></i>
                        <div><strong>Interactive Question Palette:</strong> Color-coded indicators for Answered, Unanswered, and Marked for Review with jump navigation.</div>
                    </li>
                    <li class="d-flex align-items-start gap-3">
                        <i class="bi bi-check-circle-fill text-success fs-5"></i>
                        <div><strong>Instant Automated Evaluation:</strong> Automatic scoring, percentage calculation, academic grade assignment, and downloadable marksheet.</div>
                    </li>
                </ul>
            </div>
            <div class="col-lg-6">
                <div class="p-4 rounded-4 shadow-sm border bg-light">
                    <h5 class="fw-bold mb-3"><i class="bi bi-cpu-fill text-primary me-2"></i>Technology Stack</h5>
                    <div class="row g-3">
                        <div class="col-6">
                            <div class="bg-white p-3 rounded-3 border">
                                <small class="text-muted text-uppercase fw-bold">Backend</small>
                                <div class="fw-bold text-dark mt-1">Java 21 &amp; Jakarta Servlets 6.0</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="bg-white p-3 rounded-3 border">
                                <small class="text-muted text-uppercase fw-bold">View Engine</small>
                                <div class="fw-bold text-dark mt-1">JSP 3.1 &amp; JSTL 3.0</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="bg-white p-3 rounded-3 border">
                                <small class="text-muted text-uppercase fw-bold">Database</small>
                                <div class="fw-bold text-dark mt-1">MySQL 8.x (JDBC)</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="bg-white p-3 rounded-3 border">
                                <small class="text-muted text-uppercase fw-bold">App Server</small>
                                <div class="fw-bold text-dark mt-1">Apache Tomcat 10.1</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="bg-white p-3 rounded-3 border">
                                <small class="text-muted text-uppercase fw-bold">Security</small>
                                <div class="fw-bold text-dark mt-1">PBKDF2-SHA256 &amp; RBAC</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="bg-white p-3 rounded-3 border">
                                <small class="text-muted text-uppercase fw-bold">Frontend</small>
                                <div class="fw-bold text-dark mt-1">HTML5, CSS3, ES6 &amp; BS5</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="py-4 bg-dark text-white-50 text-center border-top border-secondary">
    <div class="container">
        <p class="mb-0">&copy; Online Examination and Result Management System | Built with Jakarta EE &amp; MySQL</p>
    </div>
</footer>

<jsp:include page="/includes/footer.jsp" />
