<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Sign In - Online Examination Portal" />
<jsp:include page="/includes/header.jsp" />

<style>
    .auth-page {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: radial-gradient(circle at 50% 20%, #1e293b 0%, #0f172a 100%);
        padding: 2rem 1rem;
    }
    .auth-card {
        background: white;
        border-radius: 16px;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2), 0 10px 10px -5px rgba(0, 0, 0, 0.1);
        width: 100%;
        max-width: 460px;
        overflow: hidden;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }
    .auth-header {
        background-color: #0f172a;
        color: white;
        padding: 2rem;
        text-align: center;
    }
    .auth-body {
        padding: 2.25rem 2rem;
    }
    .quick-role-pill {
        cursor: pointer;
        font-size: 0.78rem;
        font-weight: 600;
        padding: 0.45rem 0.85rem;
        border-radius: 9999px;
        border: 1px solid #cbd5e1;
        background: #f8fafc;
        color: #334155;
        transition: all 0.15s;
    }
    .quick-role-pill:hover {
        background: #e2e8f0;
        transform: translateY(-1px);
    }
</style>

<div class="auth-page">
    <div class="auth-card">
        <div class="auth-header">
            <a href="${pageContext.request.contextPath}/" class="text-decoration-none text-white d-inline-flex align-items-center gap-2 mb-2">
                <i class="bi bi-mortarboard-fill text-primary fs-3"></i>
                <span class="fs-4 fw-bold">ExamPortal Pro</span>
            </a>
            <p class="text-white-50 mb-0 small">Sign in to your authorized account</p>
        </div>

        <div class="auth-body">
            <!-- Alert Messages -->
            <c:if test="${not empty param.msg}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ${param.msg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${param.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Quick Autofill Role Shortcuts -->
            <div class="mb-4">
                <label class="form-label text-muted fw-bold small text-uppercase mb-2">Quick Demo Autofill</label>
                <div class="d-flex flex-wrap gap-2">
                    <span class="quick-role-pill" onclick="fillCredentials('admin', 'admin123')">
                        <i class="bi bi-shield-lock-fill text-danger me-1"></i> Admin
                    </span>
                    <span class="quick-role-pill" onclick="fillCredentials('dr.sharma', 'teacher123')">
                        <i class="bi bi-person-badge-fill text-primary me-1"></i> Teacher
                    </span>
                    <span class="quick-role-pill" onclick="fillCredentials('rohit.kumar', 'student123')">
                        <i class="bi bi-mortarboard-fill text-success me-1"></i> Student
                    </span>
                </div>
            </div>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label for="identifier" class="form-label fw-semibold">Username or Email</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light text-muted"><i class="bi bi-person"></i></span>
                        <input type="text" class="form-control" id="identifier" name="identifier" 
                               value="${enteredIdentifier != null ? enteredIdentifier : ''}" 
                               placeholder="e.g. admin or roll number" required autofocus>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label for="password" class="form-label fw-semibold mb-0">Password</label>
                    </div>
                    <div class="input-group">
                        <span class="input-group-text bg-light text-muted"><i class="bi bi-lock"></i></span>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="••••••••" required>
                        <button type="button" class="btn btn-outline-secondary" onclick="togglePasswordVisibility()">
                            <i class="bi bi-eye" id="togglePasswordIcon"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fw-bold rounded-3 mb-3 shadow-sm" style="background-color: var(--accent); border: none;">
                    <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                </button>

                <div class="text-center mt-3 pt-3 border-top">
                    <span class="text-muted small">New student?</span>
                    <a href="${pageContext.request.contextPath}/register" class="fw-bold text-primary small text-decoration-none ms-1">
                        Register Account
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function fillCredentials(user, pass) {
        document.getElementById('identifier').value = user;
        document.getElementById('password').value = pass;
    }

    function togglePasswordVisibility() {
        const input = document.getElementById('password');
        const icon = document.getElementById('togglePasswordIcon');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        }
    }

    // Auto-fill role if passed in query param
    const urlParams = new URLSearchParams(window.location.search);
    const roleParam = urlParams.get('role');
    if (roleParam === 'admin') fillCredentials('admin', 'admin123');
    else if (roleParam === 'teacher') fillCredentials('dr.sharma', 'teacher123');
    else if (roleParam === 'student') fillCredentials('rohit.kumar', 'student123');
</script>

<jsp:include page="/includes/footer.jsp" />

