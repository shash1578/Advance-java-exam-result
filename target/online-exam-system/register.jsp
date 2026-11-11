<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Registration - Online Examination Portal" />
<jsp:include page="/includes/header.jsp" />

<style>
    .auth-page {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: radial-gradient(circle at 50% 20%, #1e293b 0%, #0f172a 100%);
        padding: 3rem 1rem;
    }
    .register-card {
        background: white;
        border-radius: 16px;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2);
        width: 100%;
        max-width: 650px;
        overflow: hidden;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }
</style>

<div class="auth-page">
    <div class="register-card">
        <div class="bg-dark text-white p-4 text-center" style="background-color: #0f172a !important;">
            <a href="${pageContext.request.contextPath}/" class="text-decoration-none text-white d-inline-flex align-items-center gap-2 mb-1">
                <i class="bi bi-mortarboard-fill text-primary fs-3"></i>
                <span class="fs-4 fw-bold">ExamPortal Pro</span>
            </a>
            <h5 class="fw-bold mb-0">Student Registration</h5>
            <p class="text-white-50 small mb-0">Create your examinee profile to access online examinations</p>
        </div>

        <div class="p-4 p-md-5">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" class="validate-password-match">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="fullName" class="form-label fw-semibold">Full Name *</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" placeholder="e.g. Rahul Sharma" required>
                    </div>

                    <div class="col-md-6">
                        <label for="rollNumber" class="form-label fw-semibold">Roll Number *</label>
                        <input type="text" class="form-control" id="rollNumber" name="rollNumber" placeholder="e.g. CS2024-005" required>
                    </div>

                    <div class="col-md-6">
                        <label for="username" class="form-label fw-semibold">Username *</label>
                        <input type="text" class="form-control" id="username" name="username" placeholder="e.g. rahul.sharma" required>
                    </div>

                    <div class="col-md-6">
                        <label for="email" class="form-label fw-semibold">Email Address *</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="e.g. rahul@example.com" required>
                    </div>

                    <div class="col-md-6">
                        <label for="department" class="form-label fw-semibold">Department *</label>
                        <select class="form-select" id="department" name="department" required>
                            <option value="">Select Department</option>
                            <option value="Computer Science & Engineering">Computer Science &amp; Engineering</option>
                            <option value="Information Technology">Information Technology</option>
                            <option value="Electronics & Communication">Electronics &amp; Communication</option>
                            <option value="Electrical Engineering">Electrical Engineering</option>
                            <option value="Mechanical Engineering">Mechanical Engineering</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="admissionYear" class="form-label fw-semibold">Admission Year</label>
                        <input type="number" class="form-control" id="admissionYear" name="admissionYear" value="2024" min="2020" max="2030">
                    </div>

                    <div class="col-md-3">
                        <label for="phone" class="form-label fw-semibold">Phone</label>
                        <input type="text" class="form-control" id="phone" name="phone" placeholder="+1-555-0199">
                    </div>

                    <div class="col-md-6">
                        <label for="password" class="form-label fw-semibold">Password (min 6 chars) *</label>
                        <input type="password" class="form-control" id="password" name="password" minlength="6" required>
                    </div>

                    <div class="col-md-6">
                        <label for="confirmPassword" class="form-label fw-semibold">Confirm Password *</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" minlength="6" required>
                    </div>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold rounded-3 shadow-sm" style="background-color: var(--accent); border: none;">
                        <i class="bi bi-person-check-fill me-1"></i> Complete Registration
                    </button>
                </div>

                <div class="text-center mt-3 pt-3 border-top">
                    <span class="text-muted small">Already have an account?</span>
                    <a href="${pageContext.request.contextPath}/login" class="fw-bold text-primary small text-decoration-none ms-1">
                        Sign In Here
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

