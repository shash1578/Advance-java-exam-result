<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Answer Sheet Review - Online Examination System" />
<c:set var="activePage" value="attempts" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/teacher-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-file-earmark-person-fill text-primary me-2"></i>Student Answer Sheet Review</h1>
            </div>
            <div class="header-right">
                <a href="${pageContext.request.contextPath}/teacher/attempts?examId=${exam.id}" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back to Attempts
                </a>
            </div>
        </header>

        <div class="app-content">
            <!-- Student & Exam Header Card -->
            <div class="card-modern mb-4 bg-light border">
                <div class="card-body-modern p-4">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <div>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <span class="badge bg-dark">${attempt.studentRollNumber}</span>
                                <h3 class="fw-bold mb-0 text-dark">${attempt.studentName}</h3>
                            </div>
                            <div class="text-muted">
                                <span>${attempt.studentDepartment}</span> &bull; 
                                <span class="fw-semibold text-primary">${exam.title} (${exam.subjectCode})</span>
                            </div>
                            <div class="small text-muted mt-1">
                                <i class="bi bi-clock me-1"></i>Started: ${attempt.startTime} &bull; Submitted: ${attempt.endTime}
                            </div>
                        </div>

                        <!-- Scorecard Pill -->
                        <div class="d-flex align-items-center gap-3 bg-white p-3 rounded-4 border shadow-sm">
                            <div class="text-center px-3 border-end">
                                <div class="fs-3 fw-bold text-dark">${result.obtainedMarks} / ${result.totalMarks}</div>
                                <small class="text-muted text-uppercase fw-bold">Score</small>
                            </div>
                            <div class="text-center px-3 border-end">
                                <div class="fs-3 fw-bold text-primary">${result.percentage}%</div>
                                <small class="text-muted text-uppercase fw-bold">Percentage</small>
                            </div>
                            <div class="text-center px-3 border-end">
                                <div class="fs-3 fw-bold text-info">${result.grade}</div>
                                <small class="text-muted text-uppercase fw-bold">Grade</small>
                            </div>
                            <div class="text-center px-2">
                                <span class="badge-status ${result.status == 'PASS' ? 'pass' : 'fail'} fs-6 py-2 px-3">
                                    ${result.status}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Question by Question Breakdown -->
            <h4 class="fw-bold text-dark mb-3"><i class="bi bi-list-check text-primary me-2"></i>Question-by-Question Evaluation</h4>

            <div class="d-flex flex-column gap-3">
                <c:forEach var="ans" items="${answers}" varStatus="loop">
                    <div class="card-modern mb-0 border ${ans.correct == true ? 'border-success' : (ans.correct == false ? 'border-danger' : 'border-secondary')}">
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
                                <span class="badge bg-light text-dark border">Max: ${ans.questionMarks} Marks</span>
                            </div>

                            <h5 class="fw-bold text-dark mb-3">${ans.questionText}</h5>

                            <!-- Options Grid -->
                            <div class="row g-2 mb-3">
                                <div class="col-md-6">
                                    <div class="p-2 rounded-3 border ${ans.correctOption == 'A' ? 'border-success bg-success-subtle fw-bold' : (ans.selectedOption == 'A' ? 'border-danger bg-danger-subtle' : 'bg-light')}">
                                        <span class="badge ${ans.correctOption == 'A' ? 'bg-success' : (ans.selectedOption == 'A' ? 'bg-danger' : 'bg-secondary')} me-2">A</span>
                                        ${ans.optionA}
                                        <c:if test="${ans.selectedOption == 'A'}">
                                            <span class="badge bg-dark ms-2">Student's Choice</span>
                                        </c:if>
                                        <c:if test="${ans.correctOption == 'A'}">
                                            <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Option"></i>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-2 rounded-3 border ${ans.correctOption == 'B' ? 'border-success bg-success-subtle fw-bold' : (ans.selectedOption == 'B' ? 'border-danger bg-danger-subtle' : 'bg-light')}">
                                        <span class="badge ${ans.correctOption == 'B' ? 'bg-success' : (ans.selectedOption == 'B' ? 'bg-danger' : 'bg-secondary')} me-2">B</span>
                                        ${ans.optionB}
                                        <c:if test="${ans.selectedOption == 'B'}">
                                            <span class="badge bg-dark ms-2">Student's Choice</span>
                                        </c:if>
                                        <c:if test="${ans.correctOption == 'B'}">
                                            <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Option"></i>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-2 rounded-3 border ${ans.correctOption == 'C' ? 'border-success bg-success-subtle fw-bold' : (ans.selectedOption == 'C' ? 'border-danger bg-danger-subtle' : 'bg-light')}">
                                        <span class="badge ${ans.correctOption == 'C' ? 'bg-success' : (ans.selectedOption == 'C' ? 'bg-danger' : 'bg-secondary')} me-2">C</span>
                                        ${ans.optionC}
                                        <c:if test="${ans.selectedOption == 'C'}">
                                            <span class="badge bg-dark ms-2">Student's Choice</span>
                                        </c:if>
                                        <c:if test="${ans.correctOption == 'C'}">
                                            <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Option"></i>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-2 rounded-3 border ${ans.correctOption == 'D' ? 'border-success bg-success-subtle fw-bold' : (ans.selectedOption == 'D' ? 'border-danger bg-danger-subtle' : 'bg-light')}">
                                        <span class="badge ${ans.correctOption == 'D' ? 'bg-success' : (ans.selectedOption == 'D' ? 'bg-danger' : 'bg-secondary')} me-2">D</span>
                                        ${ans.optionD}
                                        <c:if test="${ans.selectedOption == 'D'}">
                                            <span class="badge bg-dark ms-2">Student's Choice</span>
                                        </c:if>
                                        <c:if test="${ans.correctOption == 'D'}">
                                            <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Option"></i>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${not empty ans.explanation}">
                                <div class="p-2 bg-info-subtle border border-info-subtle rounded-3 small text-secondary">
                                    <strong class="text-primary"><i class="bi bi-info-circle me-1"></i>Explanation:</strong> ${ans.explanation}
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

