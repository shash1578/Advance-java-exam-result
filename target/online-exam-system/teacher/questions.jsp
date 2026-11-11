<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Questions - ${exam.title} - Online Examination System" />
<c:set var="activePage" value="exams" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/teacher-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-patch-question-fill text-primary me-2"></i>MCQ Questions Manager</h1>
            </div>
            <div class="header-right d-flex gap-2">
                <a href="${pageContext.request.contextPath}/teacher/exams" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back to Exams
                </a>
                <button type="button" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addQuestionModal">
                    <i class="bi bi-plus-circle-fill"></i> Add Question
                </button>
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

            <!-- Exam Overview Banner -->
            <div class="card-modern mb-4 bg-light">
                <div class="card-body-modern py-3">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                        <div>
                            <span class="badge bg-primary text-uppercase">${exam.subjectCode}: ${exam.subjectName}</span>
                            <h4 class="fw-bold text-dark mt-1 mb-1">${exam.title}</h4>
                            <small class="text-muted">
                                Duration: ${exam.durationMinutes} mins | Passing Marks: ${exam.passingMarks} | Total Marks: ${exam.totalMarks}
                            </small>
                        </div>
                        <div class="text-end">
                            <span class="fs-4 fw-bold text-primary">${questions.size()}</span>
                            <small class="text-muted d-block">Questions Configured</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Questions List -->
            <c:choose>
                <c:when test="${not empty questions}">
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="q" items="${questions}" varStatus="loop">
                            <div class="card-modern mb-0">
                                <div class="card-body-modern p-4">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="badge bg-dark fs-6">Q${loop.count}</span>
                                            <span class="badge bg-primary-subtle text-primary fw-bold">${q.marks} Marks</span>
                                        </div>
                                        <div class="btn-group btn-group-sm">
                                            <button type="button" class="btn btn-outline-primary" 
                                                    onclick="openEditQuestionModal(${q.id}, '${q.correctOption}', ${q.marks})"
                                                    title="Edit Question">
                                                <i class="bi bi-pencil-square"></i> Edit
                                            </button>
                                            <button type="button" class="btn btn-outline-danger" 
                                                    onclick="confirmDeleteQuestion(${q.id})" title="Delete Question">
                                                <i class="bi bi-trash"></i> Delete
                                            </button>
                                        </div>
                                    </div>

                                    <h5 class="fw-bold text-dark mb-3" id="q_text_${q.id}">${q.questionText}</h5>

                                    <!-- 4 Options Grid -->
                                    <div class="row g-2 mb-3">
                                        <div class="col-md-6">
                                            <div class="p-2 border rounded-3 ${q.correctOption == 'A' ? 'border-success bg-success-subtle fw-bold' : 'bg-light'}">
                                                <span class="badge ${q.correctOption == 'A' ? 'bg-success' : 'bg-secondary'} me-2">A</span>
                                                <span id="q_optA_${q.id}">${q.optionA}</span>
                                                <c:if test="${q.correctOption == 'A'}">
                                                    <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Answer"></i>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="p-2 border rounded-3 ${q.correctOption == 'B' ? 'border-success bg-success-subtle fw-bold' : 'bg-light'}">
                                                <span class="badge ${q.correctOption == 'B' ? 'bg-success' : 'bg-secondary'} me-2">B</span>
                                                <span id="q_optB_${q.id}">${q.optionB}</span>
                                                <c:if test="${q.correctOption == 'B'}">
                                                    <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Answer"></i>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="p-2 border rounded-3 ${q.correctOption == 'C' ? 'border-success bg-success-subtle fw-bold' : 'bg-light'}">
                                                <span class="badge ${q.correctOption == 'C' ? 'bg-success' : 'bg-secondary'} me-2">C</span>
                                                <span id="q_optC_${q.id}">${q.optionC}</span>
                                                <c:if test="${q.correctOption == 'C'}">
                                                    <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Answer"></i>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="p-2 border rounded-3 ${q.correctOption == 'D' ? 'border-success bg-success-subtle fw-bold' : 'bg-light'}">
                                                <span class="badge ${q.correctOption == 'D' ? 'bg-success' : 'bg-secondary'} me-2">D</span>
                                                <span id="q_optD_${q.id}">${q.optionD}</span>
                                                <c:if test="${q.correctOption == 'D'}">
                                                    <i class="bi bi-check-circle-fill text-success ms-1" title="Correct Answer"></i>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test="${not empty q.explanation}">
                                        <div class="p-2 bg-info-subtle border border-info-subtle rounded-3 small text-secondary">
                                            <strong class="text-primary"><i class="bi bi-info-circle me-1"></i>Explanation:</strong> 
                                            <span id="q_exp_${q.id}">${q.explanation}</span>
                                        </div>
                                    </c:if>
                                    <div class="d-none" id="q_exp_raw_${q.id}">${q.explanation}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card-modern text-center py-5">
                        <div class="py-5">
                            <i class="bi bi-patch-question text-muted display-4"></i>
                            <h4 class="fw-bold mt-3">No Questions Added Yet</h4>
                            <p class="text-muted">Start creating multiple-choice questions for this examination.</p>
                            <button type="button" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addQuestionModal">
                                <i class="bi bi-plus-circle-fill me-1"></i> Add First Question
                            </button>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<!-- Add Question Modal -->
<div class="modal fade" id="addQuestionModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/teacher/questions" method="post">
                <input type="hidden" name="examId" value="${exam.id}">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle-fill text-primary me-2"></i>Add MCQ Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Question Text *</label>
                        <textarea class="form-control" name="questionText" rows="3" placeholder="Enter the question statement clearly..." required></textarea>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Option A *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light fw-bold">A</span>
                                <input type="text" class="form-control" name="optionA" placeholder="First option" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Option B *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light fw-bold">B</span>
                                <input type="text" class="form-control" name="optionB" placeholder="Second option" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Option C *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light fw-bold">C</span>
                                <input type="text" class="form-control" name="optionC" placeholder="Third option" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Option D *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light fw-bold">D</span>
                                <input type="text" class="form-control" name="optionD" placeholder="Fourth option" required>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-success">Correct Option *</label>
                            <select class="form-select border-success" name="correctOption" required>
                                <option value="">-- Select Correct Option --</option>
                                <option value="A">Option A</option>
                                <option value="B">Option B</option>
                                <option value="C">Option C</option>
                                <option value="D">Option D</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Marks Allocated *</label>
                            <input type="number" class="form-control" name="marks" value="5" min="1" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Explanation / Feedback (shown after submission)</label>
                        <textarea class="form-control" name="explanation" rows="2" placeholder="Explain why the answer is correct..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom">Save Question</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Question Modal -->
<div class="modal fade" id="editQuestionModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/teacher/questions" method="post">
                <input type="hidden" name="examId" value="${exam.id}">
                <input type="hidden" name="questionId" id="edit_questionId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square text-primary me-2"></i>Edit Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Question Text *</label>
                        <textarea class="form-control" id="edit_questionText" name="questionText" rows="3" required></textarea>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Option A *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light fw-bold">A</span>
                                <input type="text" class="form-control" id="edit_optionA" name="optionA" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Option B *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light fw-bold">B</span>
                                <input type="text" class="form-control" id="edit_optionB" name="optionB" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Option C *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light fw-bold">C</span>
                                <input type="text" class="form-control" id="edit_optionC" name="optionC" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Option D *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light fw-bold">D</span>
                                <input type="text" class="form-control" id="edit_optionD" name="optionD" required>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-success">Correct Option *</label>
                            <select class="form-select border-success" id="edit_correctOption" name="correctOption" required>
                                <option value="A">Option A</option>
                                <option value="B">Option B</option>
                                <option value="C">Option C</option>
                                <option value="D">Option D</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Marks Allocated *</label>
                            <input type="number" class="form-control" id="edit_marks" name="marks" min="1" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Explanation</label>
                        <textarea class="form-control" id="edit_explanation" name="explanation" rows="2"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom">Update Question</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Question Modal -->
<div class="modal fade" id="deleteQuestionModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/teacher/questions" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="examId" value="${exam.id}">
                <input type="hidden" name="questionId" id="delete_questionId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger"><i class="bi bi-trash me-2"></i>Delete Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <p>Are you sure you want to permanently delete this MCQ question from the examination?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Confirm Delete</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openEditQuestionModal(qId, correctOpt, marks) {
        document.getElementById('edit_questionId').value = qId;
        document.getElementById('edit_questionText').value = document.getElementById('q_text_' + qId).textContent.trim();
        document.getElementById('edit_optionA').value = document.getElementById('q_optA_' + qId).textContent.trim();
        document.getElementById('edit_optionB').value = document.getElementById('q_optB_' + qId).textContent.trim();
        document.getElementById('edit_optionC').value = document.getElementById('q_optC_' + qId).textContent.trim();
        document.getElementById('edit_optionD').value = document.getElementById('q_optD_' + qId).textContent.trim();
        document.getElementById('edit_correctOption').value = correctOpt;
        document.getElementById('edit_marks').value = marks;

        const rawExp = document.getElementById('q_exp_raw_' + qId);
        document.getElementById('edit_explanation').value = rawExp ? rawExp.textContent.trim() : '';

        new bootstrap.Modal(document.getElementById('editQuestionModal')).show();
    }

    function confirmDeleteQuestion(qId) {
        document.getElementById('delete_questionId').value = qId;
        new bootstrap.Modal(document.getElementById('deleteQuestionModal')).show();
    }
</script>

<jsp:include page="/includes/footer.jsp" />

