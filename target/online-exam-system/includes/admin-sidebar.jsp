<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="app-sidebar">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-brand">
        <i class="bi bi-mortarboard-fill"></i>
        <span>ExamPortal Admin</span>
    </a>

    <div class="sidebar-nav">
        <div class="nav-section-title">Core Management</div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" 
           class="nav-link ${activePage == 'dashboard' ? 'active' : ''}">
            <i class="bi bi-speedometer2"></i>
            <span>Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/students" 
           class="nav-link ${activePage == 'students' ? 'active' : ''}">
            <i class="bi bi-people-fill"></i>
            <span>Manage Students</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/teachers" 
           class="nav-link ${activePage == 'teachers' ? 'active' : ''}">
            <i class="bi bi-person-badge-fill"></i>
            <span>Manage Teachers</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/subjects" 
           class="nav-link ${activePage == 'subjects' ? 'active' : ''}">
            <i class="bi bi-journal-bookmark-fill"></i>
            <span>Manage Subjects</span>
        </a>

        <div class="nav-section-title mt-3">Examinations</div>
        <a href="${pageContext.request.contextPath}/admin/exams" 
           class="nav-link ${activePage == 'exams' ? 'active' : ''}">
            <i class="bi bi-card-checklist"></i>
            <span>All Examinations</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/results" 
           class="nav-link ${activePage == 'results' ? 'active' : ''}">
            <i class="bi bi-trophy-fill"></i>
            <span>All Results</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/student-performance" 
           class="nav-link ${activePage == 'performance' ? 'active' : ''}">
            <i class="bi bi-graph-up-arrow"></i>
            <span>Student Performance</span>
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
            <span class="user-role-badge role-admin">Administrator</span>
        </div>
    </div>
</aside>

