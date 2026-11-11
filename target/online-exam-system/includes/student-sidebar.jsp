<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="app-sidebar">
    <a href="${pageContext.request.contextPath}/student/dashboard" class="sidebar-brand">
        <i class="bi bi-mortarboard-fill"></i>
        <span>ExamPortal Student</span>
    </a>

    <div class="sidebar-nav">
        <div class="nav-section-title">Student Portal</div>
        <a href="${pageContext.request.contextPath}/student/dashboard" 
           class="nav-link ${activePage == 'dashboard' ? 'active' : ''}">
            <i class="bi bi-speedometer2"></i>
            <span>Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/student/exams" 
           class="nav-link ${activePage == 'exams' ? 'active' : ''}">
            <i class="bi bi-journal-check"></i>
            <span>Examinations</span>
        </a>
        <a href="${pageContext.request.contextPath}/student/results" 
           class="nav-link ${activePage == 'results' ? 'active' : ''}">
            <i class="bi bi-award-fill"></i>
            <span>My Results & Marksheets</span>
        </a>

        <div class="nav-section-title mt-3">Account</div>
        <a href="${pageContext.request.contextPath}/profile" 
           class="nav-link ${activePage == 'profile' ? 'active' : ''}">
            <i class="bi bi-person-circle"></i>
            <span>My Profile</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
            <i class="bi bi-box-arrow-right text-danger"></i>
            <span>Logout</span>
        </a>
    </div>

    <div class="sidebar-user">
        <div class="user-avatar">
            ${sessionScope.currentUser.fullName.substring(0, 1).toUpperCase()}
        </div>
        <div class="user-meta">
            <div class="user-name">${sessionScope.currentUser.fullName}</div>
            <div class="d-flex align-items-center gap-1">
                <span class="user-role-badge role-student">Student</span>
                <c:if test="${not empty sessionScope.currentStudent}">
                    <small class="text-white-50" style="font-size: 0.7rem;">(${sessionScope.currentStudent.rollNumber})</small>
                </c:if>
            </div>
        </div>
    </div>
</aside>

