<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Result Scorecard - ${result.examTitle}" />
<c:set var="activePage" value="results" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-trophy-fill text-warning me-2"></i>Examination Result Scorecard</h1>
            </div>
            <div class="header-right d-flex gap-2">
                <a href="${pageContext.request.contextPath}/student/download-marksheet?attemptId=${result.attemptId}" 
                   class="btn btn-outline-success btn-sm fw-bold" target="_blank">
                    <i class="bi bi-printer-fill me-1"></i> Download PDF Marksheet
                </a>
                <a href="${pageContext.request.contextPath}/student/results" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back to Results
                </a>
            </div>
        </header>

        <div class="app-content">
            <!-- Submission Confirmation Toast -->
            <c:if test="${not empty param.submitted}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    <h5 class="fw-bold mb-1"><i class="bi bi-check-circle-fill me-2"></i>Examination Submitted Successfully!</h5>
                    Your responses have been securely evaluated against the server answer key and recorded in the database.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Main Scorecard Hero Card -->
            <div class="card-modern overflow-hidden mb-4 border-0 shadow">
                <div class="scorecard-header text-center">
                    <span class="badge bg-light text-dark mb-2 px-3 py-2 fw-bold">${result.subjectCode}: ${result.subjectName}</span>
                    <h2 class="fw-bold text-white mb-3">${result.examTitle}</h2>

                    <!-- Circular Percentage Display -->
                    <div class="scorecard-circle">
                        <span class="score-number">${result.percentage}%</span>
                        <span class="score-label">Score</span>
                    </div>

                    <!-- Pass / Fail Banner Badge -->
                    <div>
                        <span class="badge ${result.status == 'PASS' ? 'bg-success' : 'bg-danger'} fs-5 px-4 py-2 text-uppercase fw-bold shadow-sm">
                            <i class="bi ${result.status == 'PASS' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'} me-1"></i>
                            ${result.status == 'PASS' ? 'PASSED' : 'FAILED'} (Grade: ${result.grade})
                        </span>
                    </div>
                </div>

                <div class="card-body-modern p-4">
                    <!-- Key Performance Metrics Breakdown -->
                    <div class="row g-3 text-center">
                        <div class="col-sm-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border">
                                <small class="text-muted text-uppercase fw-bold">Marks Obtained</small>
                                <div class="fs-4 fw-bold text-dark mt-1">
                                    ${result.obtainedMarks} <span class="fs-6 text-muted fw-normal">/ ${result.totalMarks}</span>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-6 col-md-3">
                            <div class="p-3 bg-success-subtle rounded-3 border border-success-subtle">
                                <small class="text-success text-uppercase fw-bold">Correct Answers</small>
                                <div class="fs-4 fw-bold text-success mt-1">
                                    ${result.correctAnswers} <span class="fs-6 fw-normal">/ ${result.totalQuestions}</span>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-6 col-md-3">
                            <div class="p-3 bg-danger-subtle rounded-3 border border-danger-subtle">
                                <small class="text-danger text-uppercase fw-bold">Incorrect Answers</small>
                                <div class="fs-4 fw-bold text-danger mt-1">
                                    ${result.incorrectAnswers}
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-6 col-md-3">
                            <div class="p-3 bg-secondary-subtle rounded-3 border">
                                <small class="text-muted text-uppercase fw-bold">Unattempted</small>
                                <div class="fs-4 fw-bold text-secondary mt-1">
                                    ${result.unattempted}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Detailed Question-by-Question Review -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="fw-bold text-dark mb-0">
                    <i class="bi bi-ui-checks text-primary me-2"></i>Performance Review &amp; Answer Analysis
                </h4>
                <a href="${pageContext.request.contextPath}/student/download-marksheet?attemptId=${result.attemptId}" 
                   class="btn btn-outline-primary btn-sm fw-semibold" target="_blank">
                    <i class="bi bi-printer me-1"></i> Print / Download Marksheet
                </a>
            </div>

            <div class="d-flex flex-column gap-3 mb-5">
                <c:forEach var="ans" items="${answers}" varStatus="loop">
                    <div class="card-modern mb-0 border ${ans.correct == true ? 'border-success' : (ans.correct == false && not empty ans.selectedOption ? 'border-danger' : 'border-secondary')}">
                        <div class="card-body-modern p-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-dark fs-6">Question ${loop.count}</span>
                                    <c:choose>
                                        <c:when test="${ans.correct == true}">
                                            <span class="badge bg-success-subtle text-success fw-bold">
                                                <i class="bi bi-check-circle-fill me-1"></i> Correct (+${ans.marksAwarded} Marks)
                                            </span>
                                        </c:when>
                                        <c:when test="${ans.correct == false && not empty ans.selectedOption}">
                                            <span class="badge bg-danger-subtle text-danger fw-bold">
                                                <i class="bi bi-x-circle-fill me-1"></i> Incorrect (${ans.marksAwarded} Marks)
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-subtle text-muted fw-bold">
                                                <i class="bi bi-dash-circle me-1"></i> Unattempted (0 Marks)
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="badge bg-light text-dark border">Allocated: ${ans.questionMarks} Marks</span>
                            </div>

                            <h5 class="fw-bold text-dark mb-3">${ans.questionText}</h5>

                            <!-- Options Grid -->
                            <div class="row g-2 mb-3">
                                <div class="col-md-6">
                                    <div class="p-2 rounded-3 border ${ans.correctOption == 'A' ? 'border-success bg-success-subtle fw-bold' : (ans.selectedOption == 'A' ? 'border-danger bg-danger-subtle' : 'bg-light')}">
                                        <span class="badge ${ans.correctOption == 'A' ? 'bg-success' : (ans.selectedOption == 'A' ? 'bg-danger' : 'bg-secondary')} me-2">A</span>
                                        ${ans.optionA}
                                        <c:if test="${ans.selectedOption == 'A'}">
                                            <span class="badge bg-dark ms-2">Your Answer</span>
                                        </c:if>
                                        <c:if test="${ans.correctOption == 'A'}">
                                            <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Answer"></i>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-2 rounded-3 border ${ans.correctOption == 'B' ? 'border-success bg-success-subtle fw-bold' : (ans.selectedOption == 'B' ? 'border-danger bg-danger-subtle' : 'bg-light')}">
                                        <span class="badge ${ans.correctOption == 'B' ? 'bg-success' : (ans.selectedOption == 'B' ? 'bg-danger' : 'bg-secondary')} me-2">B</span>
                                        ${ans.optionB}
                                        <c:if test="${ans.selectedOption == 'B'}">
                                            <span class="badge bg-dark ms-2">Your Answer</span>
                                        </c:if>
                                        <c:if test="${ans.correctOption == 'B'}">
                                            <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Answer"></i>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-2 rounded-3 border ${ans.correctOption == 'C' ? 'border-success bg-success-subtle fw-bold' : (ans.selectedOption == 'C' ? 'border-danger bg-danger-subtle' : 'bg-light')}">
                                        <span class="badge ${ans.correctOption == 'C' ? 'bg-success' : (ans.selectedOption == 'C' ? 'bg-danger' : 'bg-secondary')} me-2">C</span>
                                        ${ans.optionC}
                                        <c:if test="${ans.selectedOption == 'C'}">
                                            <span class="badge bg-dark ms-2">Your Answer</span>
                                        </c:if>
                                        <c:if test="${ans.correctOption == 'C'}">
                                            <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Answer"></i>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-2 rounded-3 border ${ans.correctOption == 'D' ? 'border-success bg-success-subtle fw-bold' : (ans.selectedOption == 'D' ? 'border-danger bg-danger-subtle' : 'bg-light')}">
                                        <span class="badge ${ans.correctOption == 'D' ? 'bg-success' : (ans.selectedOption == 'D' ? 'bg-danger' : 'bg-secondary')} me-2">D</span>
                                        ${ans.optionD}
                                        <c:if test="${ans.selectedOption == 'D'}">
                                            <span class="badge bg-dark ms-2">Your Answer</span>
                                        </c:if>
                                        <c:if test="${ans.correctOption == 'D'}">
                                            <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Answer"></i>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${not empty ans.explanation}">
                                <div class="p-3 bg-info-subtle border border-info-subtle rounded-3 small text-secondary">
                                    <strong class="text-primary"><i class="bi bi-info-circle-fill me-1"></i>Instructor Explanation:</strong> 
                                    ${ans.explanation}
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />

