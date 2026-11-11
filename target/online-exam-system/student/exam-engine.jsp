<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${exam.title} - Online Examination" />
<jsp:include page="/includes/header.jsp" />

<style>
    /* Full-screen Focused Examination Layout */
    .exam-top-bar {
        background: #0f172a;
        color: white;
        padding: 0.75rem 1.5rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }
</style>

<!-- Top Examination Bar -->
<div class="exam-top-bar">
    <div class="d-flex align-items-center gap-3">
        <i class="bi bi-mortarboard-fill text-primary fs-3"></i>
        <div>
            <h5 class="fw-bold mb-0 text-white">${exam.title}</h5>
            <small class="text-white-50">${exam.subjectCode}: ${exam.subjectName} | Student: <strong>${sessionScope.currentUser.fullName}</strong> (${sessionScope.currentStudent.rollNumber})</small>
        </div>
    </div>

    <div class="d-flex align-items-center gap-3">
        <!-- Live Autosave Status Indicator -->
        <div id="saveStatusIndicator" class="small fw-semibold text-white-50 d-none d-md-block">
            <i class="bi bi-cloud-check text-success me-1"></i> Connected &amp; Synced
        </div>

        <!-- Sticky Countdown Timer -->
        <div class="exam-timer-box" id="timerBox">
            <i class="bi bi-stopwatch-fill"></i>
            <span class="timer-digits" id="timerDigits">--:--</span>
        </div>

        <!-- Submit Examination Trigger -->
        <button type="button" class="btn btn-danger fw-bold px-3 py-2" data-bs-toggle="modal" data-bs-target="#submitConfirmModal">
            <i class="bi bi-send-check me-1"></i> Submit Exam
        </button>
    </div>
</div>

<div class="container-fluid py-4 px-lg-5">
    <div class="exam-layout">
        <!-- Center Left Column: Single Question Card & Navigation -->
        <div class="question-main-panel">
            <form id="examSubmitForm" action="${pageContext.request.contextPath}/student/submit-exam" method="post">
                <input type="hidden" name="attemptId" value="${attempt.id}">

                <!-- Questions Container -->
                <div class="questions-wrapper">
                    <c:forEach var="q" items="${questions}" varStatus="loop">
                        <div class="question-item question-container" 
                             id="question_card_${loop.index}" 
                             data-question-id="${q.id}" 
                             data-marked-for-review="${q.markedForReview}" 
                             style="${loop.first ? 'display: block;' : 'display: none;'}">

                            <div class="question-meta-bar">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="question-badge">
                                        Question ${loop.count} of ${questions.size()}
                                    </span>
                                    <span class="question-marks-badge">
                                        ${q.marks} Marks
                                    </span>
                                </div>
                                <div>
                                    <c:if test="${exam.negativeMarkingPerQuestion > 0}">
                                        <span class="badge bg-danger-subtle text-danger">
                                            -${exam.negativeMarkingPerQuestion} for incorrect
                                        </span>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Question Statement -->
                            <div class="question-title">
                                ${q.questionText}
                            </div>

                            <!-- 4 Selectable Option Pills -->
                            <div class="options-list">
                                <!-- Option A -->
                                <label class="option-pill ${q.studentSelectedOption == 'A' ? 'selected' : ''}" data-option="A">
                                    <input type="radio" class="option-input d-none" name="q_${q.id}" value="A" 
                                           ${q.studentSelectedOption == 'A' ? 'checked' : ''}>
                                    <span class="option-letter">A</span>
                                    <span class="option-text">${q.optionA}</span>
                                </label>

                                <!-- Option B -->
                                <label class="option-pill ${q.studentSelectedOption == 'B' ? 'selected' : ''}" data-option="B">
                                    <input type="radio" class="option-input d-none" name="q_${q.id}" value="B" 
                                           ${q.studentSelectedOption == 'B' ? 'checked' : ''}>
                                    <span class="option-letter">B</span>
                                    <span class="option-text">${q.optionB}</span>
                                </label>

                                <!-- Option C -->
                                <label class="option-pill ${q.studentSelectedOption == 'C' ? 'selected' : ''}" data-option="C">
                                    <input type="radio" class="option-input d-none" name="q_${q.id}" value="C" 
                                           ${q.studentSelectedOption == 'C' ? 'checked' : ''}>
                                    <span class="option-letter">C</span>
                                    <span class="option-text">${q.optionC}</span>
                                </label>

                                <!-- Option D -->
                                <label class="option-pill ${q.studentSelectedOption == 'D' ? 'selected' : ''}" data-option="D">
                                    <input type="radio" class="option-input d-none" name="q_${q.id}" value="D" 
                                           ${q.studentSelectedOption == 'D' ? 'checked' : ''}>
                                    <span class="option-letter">D</span>
                                    <span class="option-text">${q.optionD}</span>
                                </label>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Examination Action Control Bar -->
                <div class="exam-action-bar">
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-warning fw-semibold" id="toggleReviewBtn">
                            <i class="bi bi-bookmark me-1"></i> Mark for Review
                        </button>
                        <button type="button" class="btn btn-outline-secondary fw-semibold" id="clearSelectionBtn">
                            <i class="bi bi-eraser me-1"></i> Clear Response
                        </button>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-primary px-4 fw-semibold" id="prevQuestionBtn">
                            <i class="bi bi-chevron-left me-1"></i> Previous
                        </button>
                        <button type="button" class="btn btn-primary px-4 fw-semibold" id="nextQuestionBtn" style="background-color: var(--accent);">
                            Next <i class="bi bi-chevron-right ms-1"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Right Column: Question Navigation Palette -->
        <div class="palette-panel">
            <div class="palette-card">
                <div class="palette-title">
                    <span><i class="bi bi-grid-3x3-gap-fill text-primary me-2"></i>Question Palette</span>
                    <span class="badge bg-light text-dark border">${questions.size()} Total</span>
                </div>

                <!-- Palette Grid Numbers 1..N -->
                <div class="palette-grid">
                    <c:forEach var="q" items="${questions}" varStatus="loop">
                        <button type="button" 
                                class="palette-btn ${loop.first ? 'current' : ''} ${q.answered ? 'answered' : ''} ${q.markedForReview ? 'review' : ''}" 
                                data-index="${loop.index}" 
                                data-question-id="${q.id}">
                            ${loop.count}
                        </button>
                    </c:forEach>
                </div>

                <!-- Palette Live Summary & Legend -->
                <div class="palette-legend">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <div class="legend-item">
                            <div class="legend-bullet answered"></div>
                            <span>Answered</span>
                        </div>
                        <span class="badge bg-success-subtle text-success fw-bold" id="countAnswered">${answeredCount}</span>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <div class="legend-item">
                            <div class="legend-bullet unanswered"></div>
                            <span>Unanswered</span>
                        </div>
                        <span class="badge bg-secondary-subtle text-muted fw-bold" id="countUnanswered">${unansweredCount}</span>
                    </div>

                    <div class="d-flex justify-content-between align-items-center">
                        <div class="legend-item">
                            <div class="legend-bullet review"></div>
                            <span>Marked for Review</span>
                        </div>
                        <span class="badge bg-warning-subtle text-warning fw-bold" id="countReview">${reviewCount}</span>
                    </div>
                </div>

                <div class="mt-4 pt-3 border-top">
                    <button type="button" class="btn btn-danger w-100 py-2 fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#submitConfirmModal">
                        <i class="bi bi-check2-all me-1"></i> Submit Examination
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Submit Confirmation Modal -->
<div class="modal fade" id="submitConfirmModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold"><i class="bi bi-question-circle text-primary me-2"></i>Final Examination Submission</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <i class="bi bi-clipboard2-check text-primary display-4 mb-3 d-inline-block"></i>
                <h4 class="fw-bold mb-2">Ready to Submit?</h4>
                <p class="text-muted mb-4">Please review your submission summary before finalizing. You will not be able to modify your answers once submitted.</p>

                <div class="row g-2 mb-3">
                    <div class="col-6">
                        <div class="p-3 bg-success-subtle rounded-3 text-center border border-success-subtle">
                            <div class="fs-4 fw-bold text-success" id="modalAnsweredCount">${answeredCount}</div>
                            <small class="text-success fw-bold">Answered</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="p-3 bg-secondary-subtle rounded-3 text-center border">
                            <div class="fs-4 fw-bold text-dark" id="modalUnansweredCount">${unansweredCount}</div>
                            <small class="text-muted fw-bold">Unanswered</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Resume Test</button>
                <button type="button" class="btn btn-danger px-4 fw-bold" id="confirmFinalSubmitBtn">
                    Confirm &amp; Submit Examination
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Exam Engine JavaScript Logic -->
<script src="${pageContext.request.contextPath}/assets/js/exam-engine.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        new ExamEngine({
            attemptId: ${attempt.id},
            totalQuestions: ${questions.size()},
            remainingSeconds: ${remainingSeconds},
            saveUrl: '${pageContext.request.contextPath}/student/save-answer',
            submitUrl: '${pageContext.request.contextPath}/student/submit-exam'
        });
    });
</script>

<jsp:include page="/includes/footer.jsp" />

