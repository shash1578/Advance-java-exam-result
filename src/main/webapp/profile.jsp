<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Profile - Online Examination System" />
<c:set var="activePage" value="profile" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <!-- Include Appropriate Role Sidebar -->
    <c:choose>
        <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
            <jsp:include page="/includes/admin-sidebar.jsp" />
        </c:when>
        <c:when test="${sessionScope.currentUser.role == 'TEACHER'}">
            <jsp:include page="/includes/teacher-sidebar.jsp" />
        </c:when>
        <c:when test="${sessionScope.currentUser.role == 'STUDENT'}">
            <jsp:include page="/includes/student-sidebar.jsp" />
        </c:when>
    </c:choose>

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-person-circle text-primary me-2"></i>Account Profile</h1>
            </div>
        </header>

        <div class="app-content">
            <!-- Alert Notifications -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty pwdSuccessMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ${pwdSuccessMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty pwdErrorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${pwdErrorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row g-4">
                <!-- Personal Info Card -->
                <div class="col-lg-7">
                    <div class="card-modern">
                        <div class="card-header-modern">
                            <h2 class="card-title"><i class="bi bi-person-vcard text-primary me-2"></i>Personal Details</h2>
                            <span class="badge bg-primary text-uppercase px-3 py-2">${sessionScope.currentUser.role}</span>
                        </div>
                        <div class="card-body-modern">
                            <form action="${pageContext.request.contextPath}/profile" method="post">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Username</label>
                                        <input type="text" class="form-control bg-light" value="${sessionScope.currentUser.username}" readonly>
                                        <small class="text-muted">Username cannot be changed</small>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="fullName" class="form-label fw-semibold">Full Name *</label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" value="${sessionScope.currentUser.fullName}" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="email" class="form-label fw-semibold">Email Address *</label>
                                        <input type="email" class="form-control" id="email" name="email" value="${sessionScope.currentUser.email}" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="phone" class="form-label fw-semibold">Phone Number</label>
                                        <input type="text" class="form-control" id="phone" name="phone" value="${sessionScope.currentUser.phone}">
                                    </div>

                                    <!-- Student specific details -->
                                    <c:if test="${sessionScope.currentUser.isStudent() && not empty studentProfile}">
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Roll Number</label>
                                            <input type="text" class="form-control bg-light" value="${studentProfile.rollNumber}" readonly>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Department</label>
                                            <input type="text" class="form-control bg-light" value="${studentProfile.department}" readonly>
                                        </div>
                                    </c:if>

                                    <!-- Teacher specific details -->
                                    <c:if test="${sessionScope.currentUser.isTeacher() && not empty teacherProfile}">
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Employee ID</label>
                                            <input type="text" class="form-control bg-light" value="${teacherProfile.employeeId}" readonly>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold">Department</label>
                                            <input type="text" class="form-control bg-light" value="${teacherProfile.department}" readonly>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label fw-semibold">Qualification</label>
                                            <input type="text" class="form-control bg-light" value="${teacherProfile.qualification}" readonly>
                                        </div>
                                    </c:if>
                                </div>

                                <div class="mt-4 text-end">
                                    <button type="submit" class="btn btn-primary-custom">
                                        <i class="bi bi-save me-1"></i> Save Profile Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Change Password Card -->
                <div class="col-lg-5">
                    <div class="card-modern">
                        <div class="card-header-modern">
                            <h2 class="card-title"><i class="bi bi-key-fill text-warning me-2"></i>Security &amp; Password</h2>
                        </div>
                        <div class="card-body-modern">
                            <form action="${pageContext.request.contextPath}/change-password" method="post" class="validate-password-match">
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label fw-semibold">Current Password *</label>
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                </div>

                                <div class="mb-3">
                                    <label for="newPassword" class="form-label fw-semibold">New Password (min 6 chars) *</label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" minlength="6" required>
                                </div>

                                <div class="mb-4">
                                    <label for="confirmPassword" class="form-label fw-semibold">Confirm New Password *</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" minlength="6" required>
                                </div>

                                <button type="submit" class="btn btn-warning w-100 fw-bold py-2 shadow-sm">
                                    <i class="bi bi-shield-lock me-1"></i> Update Password
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />

