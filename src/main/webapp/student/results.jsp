<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Results & Marksheets - Student Portal" />
<c:set var="activePage" value="results" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-award-fill text-warning me-2"></i>My Results &amp; Academic Marksheets</h1>
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

            <!-- Results History Table -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title">Completed Assessments (${results.size()})</h2>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern">
                        <thead>
                            <tr>
                                <th>Examination Title</th>
                                <th>Subject</th>
                                <th>Correct / Incorrect</th>
                                <th>Marks Obtained</th>
                                <th>Percentage</th>
                                <th>Grade</th>
                                <th>Result Status</th>
                                <th>Date</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty results}">
                                    <c:forEach var="res" items="${results}">
                                        <tr>
                                            <td class="fw-bold text-dark fs-6">${res.examTitle}</td>
                                            <td>
                                                <span class="badge bg-light text-dark border">${res.subjectCode}</span>
                                                <div class="small text-muted">${res.subjectName}</div>
                                            </td>
                                            <td>
                                                <span class="text-success fw-bold">${res.correctAnswers}</span> /
                                                <span class="text-danger fw-bold">${res.incorrectAnswers}</span>
                                                <small class="text-muted d-block">(${res.unattempted} skipped)</small>
                                            </td>
                                            <td class="fw-bold fs-6">
                                                ${res.obtainedMarks} <span class="text-muted small fw-normal">/ ${res.totalMarks}</span>
                                            </td>
                                            <td><strong>${res.percentage}%</strong></td>
                                            <td><span class="badge bg-info-subtle text-info fw-bold fs-6">${res.grade}</span></td>
                                            <td>
                                                <span class="badge-status ${res.status == 'PASS' ? 'pass' : 'fail'}">
                                                    <i class="bi ${res.status == 'PASS' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                                    ${res.status}
                                                </span>
                                            </td>
                                            <td><small class="text-muted">${res.createdAt}</small></td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/student/view-result?attemptId=${res.attemptId}" 
                                                       class="btn btn-outline-primary fw-semibold">
                                                        <i class="bi bi-eye-fill me-1"></i> Scorecard
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/student/download-marksheet?attemptId=${res.attemptId}" 
                                                       class="btn btn-outline-secondary" target="_blank" title="Official Printable Marksheet">
                                                        <i class="bi bi-printer-fill me-1"></i> Marksheet
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">
                                            You haven't attempted any examinations yet.
                                            <div class="mt-2">
                                                <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-sm btn-primary-custom">
                                                    Browse Active Exams
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

