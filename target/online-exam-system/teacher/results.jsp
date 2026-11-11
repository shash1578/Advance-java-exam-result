<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Results & Analytics - Online Examination System" />
<c:set var="activePage" value="results" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/teacher-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-bar-chart-line-fill text-primary me-2"></i>Results &amp; Performance Analytics</h1>
            </div>
            <c:if test="${not empty currentExam}">
                <div class="header-right">
                    <a href="${pageContext.request.contextPath}/teacher/export-csv?examId=${currentExam.id}" class="btn btn-outline-success btn-sm fw-bold">
                        <i class="bi bi-file-earmark-spreadsheet-fill me-1"></i> Export Results (CSV)
                    </a>
                </div>
            </c:if>
        </header>

        <div class="app-content">
            <!-- Exam Selection Card -->
            <div class="card-modern mb-4">
                <div class="card-body-modern py-3">
                    <form action="${pageContext.request.contextPath}/teacher/results" method="get" class="row g-3 align-items-center">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted text-uppercase mb-1">Select Examination</label>
                            <select class="form-select" name="examId" onchange="this.form.submit()">
                                <c:forEach var="ex" items="${teacherExams}">
                                    <option value="${ex.id}" ${currentExam.id == ex.id ? 'selected' : ''}>
                                        ${ex.title} (${ex.subjectCode})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted text-uppercase mb-1">Filter Student Results</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control" placeholder="Search by student name or roll number..." data-table-search="#teacherResultsTable">
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${not empty currentExam}">
                <!-- Class Performance KPI Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-content">
                                <div class="stat-label">Students Attempted</div>
                                <div class="stat-value">${examStats.totalStudents}</div>
                            </div>
                            <div class="stat-icon blue">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-content">
                                <div class="stat-label">Highest Score</div>
                                <div class="stat-value text-success">${examStats.highestMarks}</div>
                            </div>
                            <div class="stat-icon green">
                                <i class="bi bi-trophy-fill"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-content">
                                <div class="stat-label">Class Average</div>
                                <div class="stat-value text-primary">
                                    <fmt:formatNumber value="${examStats.averagePercentage}" maxFractionDigits="1" />%
                                </div>
                            </div>
                            <div class="stat-icon orange">
                                <i class="bi bi-graph-up"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 col-xl-3">
                        <div class="stat-card">
                            <div class="stat-content">
                                <div class="stat-label">Passed / Failed</div>
                                <div class="stat-value fs-4">
                                    <span class="text-success">${examStats.passedCount}</span> / 
                                    <span class="text-danger">${examStats.failedCount}</span>
                                </div>
                            </div>
                            <div class="stat-icon purple">
                                <i class="bi bi-pie-chart-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Results Table -->
                <div class="card-modern">
                    <div class="card-header-modern">
                        <h2 class="card-title">Scorecard Ledger: ${currentExam.title}</h2>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-modern" id="teacherResultsTable">
                            <thead>
                                <tr>
                                    <th>Rank</th>
                                    <th>Roll Number</th>
                                    <th>Student Name</th>
                                    <th>Department</th>
                                    <th>Correct / Total</th>
                                    <th>Obtained Marks</th>
                                    <th>Percentage</th>
                                    <th>Grade</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty results}">
                                        <c:forEach var="r" items="${results}" varStatus="loop">
                                            <tr>
                                                <td><span class="badge bg-secondary">#${loop.count}</span></td>
                                                <td><span class="badge bg-dark">${r.studentRollNumber}</span></td>
                                                <td class="fw-bold text-dark">${r.studentName}</td>
                                                <td>${r.studentDepartment}</td>
                                                <td>${r.correctAnswers} / ${r.totalQuestions}</td>
                                                <td class="fw-bold fs-6">${r.obtainedMarks} / ${r.totalMarks}</td>
                                                <td><strong>${r.percentage}%</strong></td>
                                                <td><span class="badge bg-info-subtle text-info fw-bold fs-6">${r.grade}</span></td>
                                                <td>
                                                    <span class="badge-status ${r.status == 'PASS' ? 'pass' : 'fail'}">
                                                        <i class="bi ${r.status == 'PASS' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                                        ${r.status}
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/teacher/student-review?attemptId=${r.attemptId}" 
                                                       class="btn btn-sm btn-outline-primary" title="Review Student Answer Sheet">
                                                        <i class="bi bi-eye-fill me-1"></i> Review
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="10" class="text-center py-5 text-muted">No students have submitted results for this examination yet.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />

