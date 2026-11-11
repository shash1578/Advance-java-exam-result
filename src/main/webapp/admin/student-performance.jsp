<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Student Performance Analytics - Online Examination System" />
<c:set var="activePage" value="performance" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-graph-up-arrow text-primary me-2"></i>Student Performance Analytics</h1>
            </div>
        </header>

        <div class="app-content">
            <!-- Student Selector Card -->
            <div class="card-modern mb-4">
                <div class="card-body-modern py-3">
                    <form action="${pageContext.request.contextPath}/admin/student-performance" method="get" class="row g-3 align-items-center">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted text-uppercase mb-1">Select Student from Roster</label>
                            <select class="form-select" name="studentId" onchange="this.form.submit()">
                                <option value="">-- Choose a Student --</option>
                                <c:forEach var="st" items="${allStudents}">
                                    <option value="${st.id}" ${selectedStudent.id == st.id ? 'selected' : ''}>
                                        ${st.fullName} (${st.rollNumber}) - ${st.department}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-bold text-muted text-uppercase mb-1">Or Search by Roll Number</label>
                            <div class="input-group">
                                <input type="text" class="form-control" name="rollNumber" placeholder="e.g. CS2024-001" value="${param.rollNumber}">
                                <button type="submit" class="btn btn-primary-custom">Search</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty performance}">
                    <!-- Student Summary Profile Banner -->
                    <div class="card-modern mb-4 bg-primary text-white border-0" style="background: linear-gradient(135deg, #0f172a 0%, #1e40af 100%) !important;">
                        <div class="card-body-modern p-4">
                            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="user-avatar" style="width: 58px; height: 58px; font-size: 1.5rem; background: rgba(255,255,255,0.2);">
                                        ${selectedStudent.fullName.substring(0, 1).toUpperCase()}
                                    </div>
                                    <div>
                                        <h3 class="fw-bold mb-1 text-white">${selectedStudent.fullName}</h3>
                                        <div class="text-white-50">
                                            <span class="badge bg-light text-dark me-2">${selectedStudent.rollNumber}</span>
                                            <span>${selectedStudent.department} (Batch ${selectedStudent.admissionYear})</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-end">
                                    <small class="text-white-50 text-uppercase fw-bold">Overall Average</small>
                                    <div class="display-6 fw-bold text-warning">
                                        <fmt:formatNumber value="${performance.averagePercentage}" maxFractionDigits="1" />%
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Performance KPI Cards -->
                    <div class="row g-4 mb-4">
                        <div class="col-sm-6 col-xl-3">
                            <div class="stat-card">
                                <div class="stat-content">
                                    <div class="stat-label">Exams Attempted</div>
                                    <div class="stat-value">${performance.totalExamsAttempted}</div>
                                </div>
                                <div class="stat-icon blue">
                                    <i class="bi bi-journal-check"></i>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <div class="stat-card">
                                <div class="stat-content">
                                    <div class="stat-label">Exams Passed</div>
                                    <div class="stat-value text-success">${performance.examsPassed}</div>
                                </div>
                                <div class="stat-icon green">
                                    <i class="bi bi-check-circle-fill"></i>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <div class="stat-card">
                                <div class="stat-content">
                                    <div class="stat-label">Exams Failed</div>
                                    <div class="stat-value text-danger">${performance.examsFailed}</div>
                                </div>
                                <div class="stat-icon red">
                                    <i class="bi bi-x-circle-fill"></i>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <div class="stat-card">
                                <div class="stat-content">
                                    <div class="stat-label">Highest Score</div>
                                    <div class="stat-value text-primary">
                                        <fmt:formatNumber value="${performance.highestPercentage}" maxFractionDigits="1" />%
                                    </div>
                                </div>
                                <div class="stat-icon orange">
                                    <i class="bi bi-trophy-fill"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Examination History Table -->
                    <div class="card-modern">
                        <div class="card-header-modern">
                            <h2 class="card-title"><i class="bi bi-clock-history text-primary me-2"></i>Attempted Examinations History</h2>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-modern">
                                <thead>
                                    <tr>
                                        <th>Examination</th>
                                        <th>Subject</th>
                                        <th>Correct / Total</th>
                                        <th>Marks</th>
                                        <th>Percentage</th>
                                        <th>Grade</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                        <th class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty performance.examResults}">
                                            <c:forEach var="r" items="${performance.examResults}">
                                                <tr>
                                                    <td class="fw-bold">${r.examTitle}</td>
                                                    <td><span class="badge bg-light text-dark border">${r.subjectCode}</span></td>
                                                    <td>${r.correctAnswers} / ${r.totalQuestions}</td>
                                                    <td class="fw-bold">${r.obtainedMarks} / ${r.totalMarks}</td>
                                                    <td><strong>${r.percentage}%</strong></td>
                                                    <td><span class="badge bg-info-subtle text-info fw-bold">${r.grade}</span></td>
                                                    <td>
                                                        <span class="badge-status ${r.status == 'PASS' ? 'pass' : 'fail'}">
                                                            <i class="bi ${r.status == 'PASS' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                                            ${r.status}
                                                        </span>
                                                    </td>
                                                    <td><small class="text-muted">${r.createdAt}</small></td>
                                                    <td class="text-end">
                                                        <a href="${pageContext.request.contextPath}/admin/download-marksheet?attemptId=${r.attemptId}" 
                                                           class="btn btn-sm btn-outline-secondary" target="_blank">
                                                            <i class="bi bi-printer me-1"></i> Marksheet
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="9" class="text-center py-4 text-muted">This student has not attempted any examinations yet.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card-modern text-center py-5">
                        <div class="py-5">
                            <i class="bi bi-search text-muted display-4"></i>
                            <h4 class="fw-bold mt-3">Select a Student to View Performance</h4>
                            <p class="text-muted">Choose a student from the dropdown above or enter their roll number to inspect their academic test analytics.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />

