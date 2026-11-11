<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="app-sidebar">
    <a href="${pageContext.request.contextPath}/teacher/dashboard" class="sidebar-brand">
        <i class="bi bi-mortarboard-fill"></i>
        <span>ExamPortal Faculty</span>
    </a>

    <div class="sidebar-nav">
        <div class="nav-section-title">Instructor Portal</div>
        <a href="${pageContext.request.contextPath}/teacher/dashboard" 
           class="nav-link ${activePage == 'dashboard' ? 'active' : ''}">
            <i class="bi bi-speedometer2"></i>
            <span>Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/teacher/exams" 
           class="nav-link ${activePage == 'exams' ? 'active' : ''}">
            <i class="bi bi-file-earmark-text-fill"></i>
            <span>My Examinations</span>
        </a>
        <a href="${pageContext.request.contextPath}/teacher/exams?action=new" 
           class="nav-link ${activePage == 'newExam' ? 'active' : ''}">
            <i class="bi bi-plus-circle-fill"></i>
            <span>Create New Exam</span>
        </a>

        <div class="nav-section-title mt-3">Submissions & Analytics</div>
        <a href="${pageContext.request.contextPath}/teacher/attempts" 
           class="nav-link ${activePage == 'attempts' ? 'active' : ''}">
            <i class="bi bi-people-fill"></i>
            <span>Student Attempts</span>
        </a>
        <a href="${pageContext.request.contextPath}/teacher/results" 
           class="nav-link ${activePage == 'results' ? 'active' : ''}">
            <i class="bi bi-bar-chart-line-fill"></i>
            <span>Results & Statistics</span>
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
            <span class="user-role-badge role-teacher">Teacher</span>
        </div>
    </div>
</aside>

