<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Examination Attempts - Online Examination System" />
<c:set var="activePage" value="attempts" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/teacher-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-people-fill text-primary me-2"></i>Student Examination Attempts</h1>
            </div>
        </header>

        <div class="app-content">
            <!-- Filter Bar -->
            <div class="card-modern mb-4">
                <div class="card-body-modern py-3">
                    <form action="${pageContext.request.contextPath}/teacher/attempts" method="get" class="row g-3 align-items-center">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted text-uppercase mb-1">Filter by Examination</label>
                            <select class="form-select" name="examId" onchange="this.form.submit()">
                                <option value="">-- All My Examinations --</option>
                                <c:forEach var="ex" items="${teacherExams}">
                                    <option value="${ex.id}" ${selectedExamId == ex.id ? 'selected' : ''}>
                                        ${ex.title} (${ex.subjectCode})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted text-uppercase mb-1">Search Student</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control" placeholder="Search by student name or roll number..." data-table-search="#attemptsTable">
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Attempts Table -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title">Recorded Attempts (${attempts.size()})</h2>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern" id="attemptsTable">
                        <thead>
                            <tr>
                                <th>Roll Number</th>
                                <th>Student Name</th>
                                <th>Department</th>
                                <th>Examination</th>
                                <th>Start Time</th>
                                <th>Submission Time</th>
                                <th>Score</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty attempts}">
                                    <c:forEach var="a" items="${attempts}">
                                        <tr>
                                            <td><span class="badge bg-dark">${a.studentRollNumber}</span></td>
                                            <td class="fw-bold text-dark">${a.studentName}</td>
                                            <td>${a.studentDepartment}</td>
                                            <td>${a.examTitle}</td>
                                            <td><small class="text-muted">${a.startTime}</small></td>
                                            <td><small class="text-muted">${a.endTime != null ? a.endTime : 'In Progress'}</small></td>
                                            <td class="fw-bold fs-6">
                                                <c:choose>
                                                    <c:when test="${a.status == 'SUBMITTED'}">
                                                        ${a.totalScore} <span class="small text-muted fw-normal">/ ${a.totalMarks}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${a.status == 'SUBMITTED'}">
                                                        <span class="badge-status pass"><i class="bi bi-check-circle-fill"></i> Submitted</span>
                                                    </c:when>
                                                    <c:when test="${a.status == 'IN_PROGRESS'}">
                                                        <span class="badge-status upcoming"><i class="bi bi-hourglass-split"></i> In Progress</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status expired">Expired</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <c:if test="${a.status == 'SUBMITTED'}">
                                                    <a href="${pageContext.request.contextPath}/teacher/student-review?attemptId=${a.id}" 
                                                       class="btn btn-sm btn-outline-primary fw-semibold" title="Inspect Student Answers">
                                                        <i class="bi bi-eye-fill me-1"></i> Review Sheet
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">No student attempts recorded for the selected examination.</td>
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

