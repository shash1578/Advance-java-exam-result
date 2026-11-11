<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Examinations - Online Examination System" />
<c:set var="activePage" value="exams" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/teacher-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-file-earmark-text-fill text-primary me-2"></i>My Examinations</h1>
            </div>
            <div class="header-right">
                <a href="${pageContext.request.contextPath}/teacher/exams?action=new" class="btn btn-primary-custom">
                    <i class="bi bi-plus-circle-fill"></i> Create New Exam
                </a>
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

            <!-- Search Bar -->
            <div class="card-modern mb-4">
                <div class="card-body-modern py-3">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control" placeholder="Search my exams by title or subject..." data-table-search="#teacherExamsTable">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Exams List Card -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title">Examinations Repository (${exams.size()})</h2>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern" id="teacherExamsTable">
                        <thead>
                            <tr>
                                <th>Exam Title</th>
                                <th>Subject</th>
                                <th>Duration / Marks</th>
                                <th>Questions</th>
                                <th>Attempts</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty exams}">
                                    <c:forEach var="ex" items="${exams}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark fs-6">${ex.title}</div>
                                                <div class="small text-muted">
                                                    <i class="bi bi-calendar3 me-1"></i>${ex.startTime} to ${ex.endTime}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border">${ex.subjectCode}</span>
                                                <div class="small text-muted">${ex.subjectName}</div>
                                            </td>
                                            <td>
                                                <div><strong>${ex.durationMinutes}</strong> mins</div>
                                                <small class="text-muted">Total: ${ex.totalMarks} | Pass: ${ex.passingMarks}</small>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/teacher/questions?examId=${ex.id}" 
                                                   class="badge bg-primary-subtle text-primary p-2 text-decoration-none">
                                                    <i class="bi bi-list-check me-1"></i> ${ex.questionCount} Questions
                                                </a>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/teacher/attempts?examId=${ex.id}" 
                                                   class="badge bg-success-subtle text-success p-2 text-decoration-none">
                                                    <i class="bi bi-people-fill me-1"></i> ${ex.attemptCount} Attempts
                                                </a>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${ex.isActive()}">
                                                        <span class="badge-status active">Active</span>
                                                    </c:when>
                                                    <c:when test="${ex.isUpcoming()}">
                                                        <span class="badge-status upcoming">Upcoming</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status expired">Concluded</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/teacher/questions?examId=${ex.id}" 
                                                       class="btn btn-outline-primary" title="Manage MCQ Questions">
                                                        <i class="bi bi-patch-question"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/teacher/results?examId=${ex.id}" 
                                                       class="btn btn-outline-info" title="View Results & Stats">
                                                        <i class="bi bi-trophy"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/teacher/exams?action=edit&id=${ex.id}" 
                                                       class="btn btn-outline-secondary" title="Edit Exam Settings">
                                                        <i class="bi bi-gear"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-outline-danger" 
                                                            onclick="confirmDeleteExam(${ex.id}, '${ex.title}')" title="Delete Exam">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            No examinations found. Click "Create New Exam" to get started!
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

<!-- Delete Exam Modal -->
<div class="modal fade" id="deleteExamModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/teacher/exams" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="examId" id="delete_examId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger"><i class="bi bi-trash me-2"></i>Delete Examination</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <p>Are you sure you want to permanently delete the examination: <strong id="delete_examTitle"></strong>?</p>
                    <p class="text-danger small mb-0"><i class="bi bi-exclamation-triangle-fill me-1"></i> All student submissions and associated questions will also be deleted.</p>
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
    function confirmDeleteExam(id, title) {
        document.getElementById('delete_examId').value = id;
        document.getElementById('delete_examTitle').textContent = title;
        new bootstrap.Modal(document.getElementById('deleteExamModal')).show();
    }
</script>

<jsp:include page="/includes/footer.jsp" />

