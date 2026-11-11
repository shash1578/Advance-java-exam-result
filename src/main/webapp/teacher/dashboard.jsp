<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Faculty Dashboard - Online Examination Portal" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/teacher-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-speedometer2 text-primary me-2"></i>Instructor Dashboard</h1>
            </div>
            <div class="header-right">
                <a href="${pageContext.request.contextPath}/teacher/exams?action=new" class="btn btn-primary-custom">
                    <i class="bi bi-plus-circle-fill"></i> Create New Exam
                </a>
            </div>
        </header>

        <div class="app-content">
            <!-- Alert Notifications -->
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

            <!-- Dashboard Metric Cards -->
            <div class="row g-4 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Exams Created</div>
                            <div class="stat-value">${stats.teacherExamsCount}</div>
                        </div>
                        <div class="stat-icon blue">
                            <i class="bi bi-journal-text"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Questions Added</div>
                            <div class="stat-value">${stats.teacherQuestionsCount}</div>
                        </div>
                        <div class="stat-icon purple">
                            <i class="bi bi-patch-question-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Student Submissions</div>
                            <div class="stat-value">${stats.teacherAttemptsCount}</div>
                        </div>
                        <div class="stat-icon green">
                            <i class="bi bi-people-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Class Average Score</div>
                            <div class="stat-value text-primary">
                                <fmt:formatNumber value="${stats.teacherAverageScore}" maxFractionDigits="1" />%
                            </div>
                        </div>
                        <div class="stat-icon orange">
                            <i class="bi bi-graph-up"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Managed Examinations Table -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title"><i class="bi bi-file-earmark-text-fill text-primary me-2"></i>My Examinations</h2>
                    <a href="${pageContext.request.contextPath}/teacher/exams?action=new" class="btn btn-sm btn-outline-primary fw-semibold">
                        <i class="bi bi-plus-lg me-1"></i> New Exam
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern">
                        <thead>
                            <tr>
                                <th>Examination Title</th>
                                <th>Subject</th>
                                <th>Duration</th>
                                <th>Total Marks</th>
                                <th>Questions</th>
                                <th>Submissions</th>
                                <th>Schedule Status</th>
                                <th class="text-end">Manage</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty exams}">
                                    <c:forEach var="ex" items="${exams}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark">${ex.title}</div>
                                                <small class="text-muted">${ex.published ? 'Published' : 'Draft'}</small>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border">${ex.subjectCode}</span>
                                                <div class="small text-muted">${ex.subjectName}</div>
                                            </td>
                                            <td>${ex.durationMinutes} mins</td>
                                            <td><strong>${ex.totalMarks}</strong> (Pass: ${ex.passingMarks})</td>
                                            <td>
                                                <span class="badge bg-secondary-subtle text-dark border">
                                                    ${ex.questionCount} Questions
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-primary-subtle text-primary fw-bold">
                                                    ${ex.attemptCount} Attempts
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${ex.isActive()}">
                                                        <span class="badge-status active">Active Now</span>
                                                    </c:when>
                                                    <c:when test="${ex.isUpcoming()}">
                                                        <span class="badge-status upcoming">Upcoming</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status expired">Concluded</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/teacher/questions?examId=${ex.id}" 
                                                       class="btn btn-outline-primary" title="Manage Questions">
                                                        <i class="bi bi-list-check"></i> Questions
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/teacher/results?examId=${ex.id}" 
                                                       class="btn btn-outline-info" title="View Results">
                                                        <i class="bi bi-trophy"></i> Results
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/teacher/exams?action=edit&id=${ex.id}" 
                                                       class="btn btn-outline-secondary" title="Edit Exam Settings">
                                                        <i class="bi bi-gear"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            You haven't created any examinations yet.
                                            <div class="mt-2">
                                                <a href="${pageContext.request.contextPath}/teacher/exams?action=new" class="btn btn-sm btn-primary-custom">
                                                    Create First Examination
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />

