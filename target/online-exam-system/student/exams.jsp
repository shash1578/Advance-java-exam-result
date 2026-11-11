<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Examinations - Student Portal" />
<c:set var="activePage" value="exams" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-journal-check text-primary me-2"></i>Examinations Catalog</h1>
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

            <!-- Navigation Tabs -->
            <ul class="nav nav-pills mb-4 gap-2" id="examTabs" role="tablist">
                <li class="nav-item">
                    <button class="nav-link active fw-bold px-4 py-2" id="available-tab" data-bs-toggle="tab" data-bs-target="#availablePane">
                        <i class="bi bi-play-circle me-1"></i> Available Now (${availableExams.size()})
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link fw-bold px-4 py-2" id="upcoming-tab" data-bs-toggle="tab" data-bs-target="#upcomingPane">
                        <i class="bi bi-calendar-event me-1"></i> Upcoming Exams (${upcomingExams.size()})
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link fw-bold px-4 py-2" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completedPane">
                        <i class="bi bi-check2-all me-1"></i> Completed Exams (${completedExams.size()})
                    </button>
                </li>
            </ul>

            <div class="tab-content">
                <!-- 1. AVAILABLE EXAMS PANE -->
                <div class="tab-pane fade show active" id="availablePane">
                    <div class="row g-4">
                        <c:choose>
                            <c:when test="${not empty availableExams}">
                                <c:forEach var="ex" items="${availableExams}">
                                    <div class="col-md-6 col-xl-4">
                                        <div class="card-modern h-100 d-flex flex-column border-top border-4 border-primary">
                                            <div class="card-body-modern p-4 d-flex flex-column flex-grow-1">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <span class="badge bg-light text-dark border">${ex.subjectCode}</span>
                                                    <span class="badge-status active">Open</span>
                                                </div>

                                                <h5 class="fw-bold text-dark mb-2">${ex.title}</h5>
                                                <p class="text-muted small mb-3 flex-grow-1">
                                                    ${empty ex.description ? 'Comprehensive multiple choice examination.' : ex.description}
                                                </p>

                                                <div class="p-3 bg-light rounded-3 mb-3 small text-secondary">
                                                    <div class="d-flex justify-content-between mb-1">
                                                        <span><i class="bi bi-clock me-1"></i>Duration:</span>
                                                        <strong>${ex.durationMinutes} mins</strong>
                                                    </div>
                                                    <div class="d-flex justify-content-between mb-1">
                                                        <span><i class="bi bi-award me-1"></i>Total Marks:</span>
                                                        <strong>${ex.totalMarks}</strong>
                                                    </div>
                                                    <div class="d-flex justify-content-between mb-1">
                                                        <span><i class="bi bi-check2-circle me-1"></i>Passing Marks:</span>
                                                        <strong>${ex.passingMarks}</strong>
                                                    </div>
                                                    <div class="d-flex justify-content-between">
                                                        <span><i class="bi bi-patch-question me-1"></i>Questions:</span>
                                                        <strong>${ex.questionCount}</strong>
                                                    </div>
                                                </div>

                                                <div class="mt-auto">
                                                    <c:choose>
                                                        <c:when test="${ex.studentAttempted && ex.studentAttemptStatus == 'IN_PROGRESS'}">
                                                            <a href="${pageContext.request.contextPath}/student/exam?attemptId=${ex.studentAttemptId}" 
                                                               class="btn btn-warning w-100 fw-bold py-2 shadow-sm">
                                                                <i class="bi bi-play-fill me-1"></i> Resume In-Progress Exam
                                                            </a>
                                                        </c:when>
                                                        <c:when test="${ex.studentAttempted && ex.studentAttemptStatus == 'SUBMITTED' && !ex.allowMultipleAttempts}">
                                                            <a href="${pageContext.request.contextPath}/student/view-result?attemptId=${ex.studentAttemptId}" 
                                                               class="btn btn-outline-secondary w-100 fw-semibold py-2">
                                                                <i class="bi bi-trophy me-1"></i> View Result Scorecard
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/student/exam-instructions?examId=${ex.id}" 
                                                               class="btn btn-primary-custom w-100 justify-content-center py-2">
                                                                <i class="bi bi-pencil-square me-1"></i> Take Examination
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="col-12">
                                    <div class="card-modern text-center py-5">
                                        <div class="py-5">
                                            <i class="bi bi-inbox text-muted display-4"></i>
                                            <h4 class="fw-bold mt-3">No Active Examinations</h4>
                                            <p class="text-muted">There are currently no open examinations scheduled for your department.</p>
                                        </div>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 2. UPCOMING EXAMS PANE -->
                <div class="tab-pane fade" id="upcomingPane">
                    <div class="row g-4">
                        <c:choose>
                            <c:when test="${not empty upcomingExams}">
                                <c:forEach var="ex" items="${upcomingExams}">
                                    <div class="col-md-6 col-xl-4">
                                        <div class="card-modern h-100 border-top border-4 border-warning">
                                            <div class="card-body-modern p-4">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <span class="badge bg-light text-dark border">${ex.subjectCode}</span>
                                                    <span class="badge-status upcoming">Scheduled</span>
                                                </div>

                                                <h5 class="fw-bold text-dark mb-2">${ex.title}</h5>
                                                <p class="text-muted small mb-3">${ex.description}</p>

                                                <div class="p-3 bg-light rounded-3 mb-3 small text-secondary">
                                                    <div class="mb-2">
                                                        <strong class="text-dark"><i class="bi bi-calendar-event me-1"></i>Starts:</strong>
                                                        <div class="text-primary fw-semibold">${ex.startTime}</div>
                                                    </div>
                                                    <div>
                                                        <strong class="text-dark"><i class="bi bi-clock me-1"></i>Duration:</strong>
                                                        <div>${ex.durationMinutes} minutes (${ex.totalMarks} Marks)</div>
                                                    </div>
                                                </div>

                                                <button class="btn btn-outline-secondary w-100 disabled" disabled>
                                                    <i class="bi bi-lock me-1"></i> Not Yet Open
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="col-12">
                                    <div class="card-modern text-center py-5">
                                        <div class="py-5">
                                            <i class="bi bi-calendar-check text-muted display-4"></i>
                                            <h4 class="fw-bold mt-3">No Upcoming Examinations</h4>
                                            <p class="text-muted">You have no upcoming tests scheduled on the calendar.</p>
                                        </div>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 3. COMPLETED EXAMS PANE -->
                <div class="tab-pane fade" id="completedPane">
                    <div class="card-modern">
                        <div class="card-header-modern">
                            <h2 class="card-title">Completed Examination History</h2>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-modern">
                                <thead>
                                    <tr>
                                        <th>Examination Title</th>
                                        <th>Subject</th>
                                        <th>Duration</th>
                                        <th>Total Marks</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty completedExams}">
                                            <c:forEach var="ex" items="${completedExams}">
                                                <tr>
                                                    <td class="fw-bold text-dark">${ex.title}</td>
                                                    <td><span class="badge bg-light text-dark border">${ex.subjectCode}</span></td>
                                                    <td>${ex.durationMinutes} mins</td>
                                                    <td>${ex.totalMarks} Marks</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/student/view-result?attemptId=${ex.studentAttemptId}" 
                                                           class="btn btn-sm btn-outline-primary">
                                                            <i class="bi bi-trophy-fill me-1"></i> View Result &amp; Marksheet
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center py-5 text-muted">No completed examinations found.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />

