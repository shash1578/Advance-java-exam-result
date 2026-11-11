<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Exam Instructions - ${exam.title}" />
<c:set var="activePage" value="exams" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/student-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-info-circle-fill text-primary me-2"></i>Examination Instructions &amp; Rules</h1>
            </div>
            <div class="header-right">
                <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back to Catalog
                </a>
            </div>
        </header>

        <div class="app-content">
            <div class="card-modern" style="max-width: 850px; margin: 0 auto;">
                <div class="card-header-modern bg-primary text-white" style="background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 100%) !important;">
                    <div>
                        <span class="badge bg-light text-dark mb-1">${exam.subjectCode}: ${exam.subjectName}</span>
                        <h3 class="fw-bold mb-0 text-white">${exam.title}</h3>
                    </div>
                </div>

                <div class="card-body-modern p-4">
                    <!-- Exam Metadata KPI Summary -->
                    <div class="row g-3 mb-4 text-center">
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border">
                                <small class="text-muted fw-bold text-uppercase">Duration</small>
                                <div class="fs-4 fw-bold text-dark mt-1">${exam.durationMinutes} Mins</div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border">
                                <small class="text-muted fw-bold text-uppercase">Total Marks</small>
                                <div class="fs-4 fw-bold text-primary mt-1">${exam.totalMarks}</div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border">
                                <small class="text-muted fw-bold text-uppercase">Passing Marks</small>
                                <div class="fs-4 fw-bold text-success mt-1">${exam.passingMarks}</div>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border">
                                <small class="text-muted fw-bold text-uppercase">Negative Marking</small>
                                <div class="fs-4 fw-bold ${exam.negativeMarkingPerQuestion > 0 ? 'text-danger' : 'text-secondary'} mt-1">
                                    ${exam.negativeMarkingPerQuestion > 0 ? exam.negativeMarkingPerQuestion : 'None'}
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- General Instructions -->
                    <h5 class="fw-bold text-dark mb-3"><i class="bi bi-card-checklist text-primary me-2"></i>Please Read the Following Rules Carefully:</h5>
                    <ol class="text-secondary lh-lg mb-4 ps-3">
                        <li>The clock will be set at the server. The countdown timer at the top right of your screen will display the remaining time available for you to complete the examination.</li>
                        <li><strong>Server-Side Timer Enforcement:</strong> When the countdown timer reaches zero, the examination will end automatically and submit your responses to the evaluation engine.</li>
                        <li><strong>Live Auto-Save:</strong> Your chosen answers are saved to the database immediately upon clicking. Accidental browser refreshes or network hiccups will not destroy your progress.</li>
                        <li>You may navigate freely between questions using the <strong>Previous</strong> and <strong>Next</strong> buttons or directly by clicking numbers on the <strong>Question Palette</strong>.</li>
                        <li>You can click <strong>Mark for Review</strong> on any question to flag it and return to it later before final submission.</li>
                        <c:if test="${exam.negativeMarkingPerQuestion > 0}">
                            <li class="text-danger fw-bold">Negative Marking: A penalty of ${exam.negativeMarkingPerQuestion} marks will be deducted for each incorrect answer.</li>
                        </c:if>
                    </ol>

                    <!-- Question Palette Symbol Guide -->
                    <div class="p-3 bg-light rounded-3 border mb-4">
                        <div class="fw-bold mb-2 text-dark">Question Palette Color Indicators:</div>
                        <div class="row g-2 text-secondary small">
                            <div class="col-sm-4 d-flex align-items-center gap-2">
                                <span class="palette-btn answered" style="width: 28px; height: 28px; font-size: 0.8rem; pointer-events: none;">1</span>
                                <span>Answered Question</span>
                            </div>
                            <div class="col-sm-4 d-flex align-items-center gap-2">
                                <span class="palette-btn" style="width: 28px; height: 28px; font-size: 0.8rem; pointer-events: none;">2</span>
                                <span>Unanswered / Not Visited</span>
                            </div>
                            <div class="col-sm-4 d-flex align-items-center gap-2">
                                <span class="palette-btn review" style="width: 28px; height: 28px; font-size: 0.8rem; pointer-events: none;">3</span>
                                <span>Marked for Review</span>
                            </div>
                        </div>
                    </div>

                    <!-- Teacher custom instructions if any -->
                    <c:if test="${not empty exam.instructions}">
                        <div class="p-3 bg-warning-subtle border border-warning-subtle rounded-3 mb-4">
                            <div class="fw-bold text-dark mb-1"><i class="bi bi-info-circle me-1"></i>Instructor Notes:</div>
                            <p class="mb-0 text-dark small" style="white-space: pre-line;">${exam.instructions}</p>
                        </div>
                    </c:if>

                    <!-- Confirmation Form -->
                    <form action="${pageContext.request.contextPath}/student/start-exam" method="post" id="instructionForm">
                        <input type="hidden" name="examId" value="${exam.id}">

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="agreeTerms" required>
                            <label class="form-check-label fw-semibold text-dark" for="agreeTerms">
                                I have read and understood all the instructions above and am ready to begin the examination.
                            </label>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i> Cancel &amp; Return
                            </a>
                            <button type="submit" class="btn btn-success btn-lg px-4 py-2 fw-bold shadow-sm" id="startExamBtn">
                                <i class="bi bi-play-circle-fill me-2"></i> Start Examination Now
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />

