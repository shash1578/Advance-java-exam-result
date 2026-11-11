<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Student Dashboard - Online Examination Portal" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-speedometer2 text-primary me-2"></i>Student Dashboard</h1>
            </div>
            <div class="header-right">
                <span class="badge bg-success-subtle text-success px-3 py-2 fw-semibold">
                    <i class="bi bi-mortarboard-fill me-1"></i> Examinee Portal
                </span>
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

            <!-- Student Welcome Banner -->
            <div class="card-modern mb-4 bg-primary text-white border-0" style="background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 100%) !important;">
                <div class="card-body-modern p-4">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <div>
                            <h3 class="fw-bold mb-1 text-white">Welcome back, ${sessionScope.currentUser.fullName}!</h3>
                            <p class="text-white-50 mb-0">
                                Roll Number: <span class="badge bg-light text-dark fw-bold me-2">${sessionScope.currentStudent.rollNumber}</span>
                                Department: <span class="text-white">${sessionScope.currentStudent.department}</span>
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-warning fw-bold px-4 py-2 shadow-sm">
                            <i class="bi bi-journal-check me-1"></i> View Available Exams
                        </a>
                    </div>
                </div>
            </div>

            <!-- Metric KPI Cards -->
            <div class="row g-4 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Available Exams</div>
                            <div class="stat-value text-primary">${stats.availableExamsCount}</div>
                        </div>
                        <div class="stat-icon blue">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Completed Exams</div>
                            <div class="stat-value text-success">${stats.completedExamsCount}</div>
                        </div>
                        <div class="stat-icon green">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Upcoming Exams</div>
                            <div class="stat-value text-warning">${stats.upcomingExamsCount}</div>
                        </div>
                        <div class="stat-icon orange">
                            <i class="bi bi-clock-history"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Average Score</div>
                            <div class="stat-value text-primary">
                                <fmt:formatNumber value="${stats.studentAveragePercentage}" maxFractionDigits="1" />%
                            </div>
                        </div>
                        <div class="stat-icon purple">
                            <i class="bi bi-award-fill"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Active Examinations Available to Take -->
            <div class="card-modern mb-4">
                <div class="card-header-modern">
                    <h2 class="card-title"><i class="bi bi-play-circle-fill text-success me-2"></i>Active Examinations (Ready to Take)</h2>
                    <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-sm btn-outline-primary fw-semibold">
                        View All
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
                                <th>Closes At</th>
                                <th>Status</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty availableExams}">
                                    <c:forEach var="ex" items="${availableExams}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark">${ex.title}</div>
                                                <small class="text-muted">Instructor: ${ex.teacherName}</small>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border">${ex.subjectCode}</span>
                                                <div class="small text-muted">${ex.subjectName}</div>
                                            </td>
                                            <td><strong>${ex.durationMinutes}</strong> mins</td>
                                            <td>${ex.totalMarks} Marks</td>
                                            <td><small class="text-danger"><i class="bi bi-alarm me-1"></i>${ex.endTime}</small></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${ex.studentAttempted && ex.studentAttemptStatus == 'SUBMITTED'}">
                                                        <span class="badge bg-secondary-subtle text-secondary">Completed</span>
                                                    </c:when>
                                                    <c:when test="${ex.studentAttempted && ex.studentAttemptStatus == 'IN_PROGRESS'}">
                                                        <span class="badge bg-warning-subtle text-warning fw-bold">In Progress</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status active">Ready</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <c:choose>
                                                    <c:when test="${ex.studentAttempted && ex.studentAttemptStatus == 'SUBMITTED' && !ex.allowMultipleAttempts}">
                                                        <a href="${pageContext.request.contextPath}/student/view-result?attemptId=${ex.studentAttemptId}" 
                                                           class="btn btn-sm btn-outline-secondary">
                                                            View Result
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${ex.studentAttempted && ex.studentAttemptStatus == 'IN_PROGRESS'}">
                                                        <a href="${pageContext.request.contextPath}/student/exam?attemptId=${ex.studentAttemptId}" 
                                                           class="btn btn-sm btn-warning fw-bold">
                                                            <i class="bi bi-play-fill"></i> Resume Exam
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/student/exam-instructions?examId=${ex.id}" 
                                                           class="btn btn-sm btn-primary-custom">
                                                            <i class="bi bi-pencil-fill me-1"></i> Take Exam
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted">No active examinations currently available.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Recent Results Card -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title"><i class="bi bi-trophy-fill text-warning me-2"></i>My Recent Results</h2>
                    <a href="${pageContext.request.contextPath}/student/results" class="btn btn-sm btn-outline-primary fw-semibold">
                        View All Results
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern">
                        <thead>
                            <tr>
                                <th>Examination</th>
                                <th>Subject</th>
                                <th>Score</th>
                                <th>Percentage</th>
                                <th>Grade</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty recentResults}">
                                    <c:forEach var="res" items="${recentResults}">
                                        <tr>
                                            <td class="fw-bold">${res.examTitle}</td>
                                            <td><span class="badge bg-light text-dark border">${res.subjectCode}</span></td>
                                            <td class="fw-bold fs-6">${res.obtainedMarks} / ${res.totalMarks}</td>
                                            <td><strong>${res.percentage}%</strong></td>
                                            <td><span class="badge bg-info-subtle text-info fw-bold fs-6">${res.grade}</span></td>
                                            <td>
                                                <span class="badge-status ${res.status == 'PASS' ? 'pass' : 'fail'}">
                                                    <i class="bi ${res.status == 'PASS' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                                    ${res.status}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/student/view-result?attemptId=${res.attemptId}" 
                                                       class="btn btn-outline-primary">
                                                        <i class="bi bi-eye"></i> Scorecard
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/student/download-marksheet?attemptId=${res.attemptId}" 
                                                       class="btn btn-outline-secondary" target="_blank">
                                                        <i class="bi bi-printer"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted">You have not completed any examinations yet.</td>
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

