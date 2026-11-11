<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="All Examination Results - Online Examination System" />
<c:set var="activePage" value="results" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-trophy-fill text-warning me-2"></i>Institutional Results Ledger</h1>
            </div>
            <c:if test="${not empty selectedExamId}">
                <div class="header-right">
                    <a href="${pageContext.request.contextPath}/admin/export-csv?examId=${selectedExamId}" class="btn btn-outline-success btn-sm fw-bold">
                        <i class="bi bi-file-earmark-spreadsheet-fill me-1"></i> Export to CSV
                    </a>
                </div>
            </c:if>
        </header>

        <div class="app-content">
            <!-- Filter Bar -->
            <div class="card-modern mb-4">
                <div class="card-body-modern py-3">
                    <form action="${pageContext.request.contextPath}/admin/results" method="get" class="row g-3 align-items-center">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted text-uppercase mb-1">Filter by Examination</label>
                            <select class="form-select" name="examId" onchange="this.form.submit()">
                                <option value="">-- All Examinations --</option>
                                <c:forEach var="ex" items="${exams}">
                                    <option value="${ex.id}" ${selectedExamId == ex.id ? 'selected' : ''}>
                                        ${ex.title} (${ex.subjectCode})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted text-uppercase mb-1">Instant Search</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control" placeholder="Search by student name or roll number..." data-table-search="#adminResultsTable">
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Results Table -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title">Recorded Assessment Results (${results.size()})</h2>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern" id="adminResultsTable">
                        <thead>
                            <tr>
                                <th>Roll Number</th>
                                <th>Student Name</th>
                                <th>Department</th>
                                <th>Examination</th>
                                <th>Correct / Incorrect</th>
                                <th>Marks Obtained</th>
                                <th>Percentage</th>
                                <th>Grade</th>
                                <th>Status</th>
                                <th class="text-end">Marksheet</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty results}">
                                    <c:forEach var="r" items="${results}">
                                        <tr>
                                            <td><span class="badge bg-dark">${r.studentRollNumber}</span></td>
                                            <td class="fw-bold text-dark">${r.studentName}</td>
                                            <td>${r.studentDepartment}</td>
                                            <td>
                                                <div class="fw-semibold">${r.examTitle}</div>
                                                <small class="text-muted">${r.subjectCode}: ${r.subjectName}</small>
                                            </td>
                                            <td>
                                                <span class="text-success fw-bold"><i class="bi bi-check-circle me-1"></i>${r.correctAnswers}</span> /
                                                <span class="text-danger fw-bold"><i class="bi bi-x-circle me-1"></i>${r.incorrectAnswers}</span>
                                                <small class="text-muted d-block">(${r.unattempted} skipped)</small>
                                            </td>
                                            <td class="fw-bold fs-6">
                                                ${r.obtainedMarks} <span class="text-muted small fw-normal">/ ${r.totalMarks}</span>
                                            </td>
                                            <td class="fw-bold">${r.percentage}%</td>
                                            <td><span class="badge bg-info-subtle text-info fw-bold fs-6">${r.grade}</span></td>
                                            <td>
                                                <span class="badge-status ${r.status == 'PASS' ? 'pass' : 'fail'}">
                                                    <i class="bi ${r.status == 'PASS' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                                    ${r.status}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/admin/download-marksheet?attemptId=${r.attemptId}" 
                                                   class="btn btn-sm btn-outline-secondary" target="_blank" title="Official Marksheet">
                                                    <i class="bi bi-printer-fill me-1"></i> Print / PDF
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="10" class="text-center py-5 text-muted">No examination results found.</td>
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

