<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Admin Dashboard - Online Examination Portal" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-speedometer2 text-primary me-2"></i>Administrator Dashboard</h1>
            </div>
            <div class="header-right">
                <span class="badge bg-danger-subtle text-danger px-3 py-2 fw-semibold">
                    <i class="bi bi-shield-lock-fill me-1"></i> Admin Console
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

            <!-- Dashboard Metric KPI Cards -->
            <div class="row g-4 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Total Students</div>
                            <div class="stat-value">${stats.totalStudents}</div>
                        </div>
                        <div class="stat-icon green">
                            <i class="bi bi-people-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Total Teachers</div>
                            <div class="stat-value">${stats.totalTeachers}</div>
                        </div>
                        <div class="stat-icon purple">
                            <i class="bi bi-person-badge-fill"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Total Examinations</div>
                            <div class="stat-value">${stats.totalExams}</div>
                        </div>
                        <div class="stat-icon blue">
                            <i class="bi bi-journal-text"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-label">Exams Attempted</div>
                            <div class="stat-value">${stats.totalAttempts}</div>
                        </div>
                        <div class="stat-icon orange">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Analytics & Recent Activity Row -->
            <div class="row g-4 mb-4">
                <!-- Institutional Pass Rate Chart Card -->
                <div class="col-lg-5">
                    <div class="card-modern h-100">
                        <div class="card-header-modern">
                            <h2 class="card-title"><i class="bi bi-pie-chart-fill text-primary me-2"></i>Pass / Fail Distribution</h2>
                        </div>
                        <div class="card-body-modern text-center">
                            <div style="max-height: 230px; position: relative;">
                                <canvas id="passRateChart"></canvas>
                            </div>
                            <div class="mt-4 p-3 bg-light rounded-3 d-flex justify-content-around">
                                <div>
                                    <small class="text-muted text-uppercase fw-bold">Overall Pass Rate</small>
                                    <div class="fs-4 fw-bold text-success">
                                        <fmt:formatNumber value="${stats.overallPassRate}" maxFractionDigits="1" />%
                                    </div>
                                </div>
                                <div>
                                    <small class="text-muted text-uppercase fw-bold">Active Subjects</small>
                                    <div class="fs-4 fw-bold text-primary">${stats.totalSubjects}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Examinations Card -->
                <div class="col-lg-7">
                    <div class="card-modern h-100">
                        <div class="card-header-modern">
                            <h2 class="card-title"><i class="bi bi-clock-history text-primary me-2"></i>Recent Examinations</h2>
                            <a href="${pageContext.request.contextPath}/admin/exams" class="btn btn-sm btn-outline-primary fw-semibold">
                                View All (${stats.totalExams})
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-modern">
                                <thead>
                                    <tr>
                                        <th>Title &amp; Subject</th>
                                        <th>Teacher</th>
                                        <th>Duration</th>
                                        <th>Questions</th>
                                        <th>Attempts</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty recentExams}">
                                            <c:forEach var="exam" items="${recentExams}">
                                                <tr>
                                                    <td>
                                                        <div class="fw-bold">${exam.title}</div>
                                                        <small class="text-muted">${exam.subjectCode}: ${exam.subjectName}</small>
                                                    </td>
                                                    <td>${exam.teacherName}</td>
                                                    <td>${exam.durationMinutes} mins</td>
                                                    <td><span class="badge bg-light text-dark border">${exam.questionCount}</span></td>
                                                    <td><span class="badge bg-primary-subtle text-primary">${exam.attemptCount}</span></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">No examinations found.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Exam Results Table -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title"><i class="bi bi-trophy-fill text-warning me-2"></i>Recent Student Results</h2>
                    <a href="${pageContext.request.contextPath}/admin/results" class="btn btn-sm btn-outline-primary fw-semibold">
                        View All Results
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern">
                        <thead>
                            <tr>
                                <th>Roll Number</th>
                                <th>Student Name</th>
                                <th>Examination</th>
                                <th>Score</th>
                                <th>Percentage</th>
                                <th>Grade</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty recentResults}">
                                    <c:forEach var="res" items="${recentResults}">
                                        <tr>
                                            <td><span class="badge bg-dark">${res.studentRollNumber}</span></td>
                                            <td class="fw-semibold">${res.studentName}</td>
                                            <td>${res.examTitle}</td>
                                            <td class="fw-bold">${res.obtainedMarks} / ${res.totalMarks}</td>
                                            <td>${res.percentage}%</td>
                                            <td><span class="badge bg-info-subtle text-info fw-bold">${res.grade}</span></td>
                                            <td>
                                                <span class="badge-status ${res.status == 'PASS' ? 'pass' : 'fail'}">
                                                    <i class="bi ${res.status == 'PASS' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                                    ${res.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/download-marksheet?attemptId=${res.attemptId}" 
                                                   class="btn btn-sm btn-outline-secondary" target="_blank" title="View Marksheet">
                                                    <i class="bi bi-printer"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-4 text-muted">No results recorded yet.</td>
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

<script>
    // Initialize Pass/Fail Distribution Donut Chart
    document.addEventListener('DOMContentLoaded', () => {
        const passRate = ${stats.overallPassRate > 0 ? stats.overallPassRate : 100};
        const failRate = (100 - passRate).toFixed(1);

        const ctx = document.getElementById('passRateChart');
        if (ctx) {
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Passed', 'Failed'],
                    datasets: [{
                        data: [passRate, failRate],
                        backgroundColor: ['#10b981', '#ef4444'],
                        borderWidth: 2,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    },
                    cutout: '70%'
                }
            });
        }
    });
</script>

<jsp:include page="/includes/footer.jsp" />

