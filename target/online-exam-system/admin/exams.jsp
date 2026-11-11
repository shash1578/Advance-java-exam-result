<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="All Examinations - Online Examination System" />
<c:set var="activePage" value="exams" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-card-checklist text-primary me-2"></i>Institutional Examinations</h1>
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

            <!-- Search Filter Bar -->
            <div class="card-modern mb-4">
                <div class="card-body-modern py-3">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control" placeholder="Search exams by title, subject, or teacher..." data-table-search="#adminExamsTable">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- All Examinations Table -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title">All Examinations (${exams.size()})</h2>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern" id="adminExamsTable">
                        <thead>
                            <tr>
                                <th>Exam Title</th>
                                <th>Subject</th>
                                <th>Instructor</th>
                                <th>Duration / Marks</th>
                                <th>Schedule Window</th>
                                <th>Questions</th>
                                <th>Attempts</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty exams}">
                                    <c:forEach var="e" items="${exams}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark">${e.title}</div>
                                                <small class="text-muted">${e.published ? 'Published' : 'Draft'}</small>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border">${e.subjectCode}</span>
                                                <div class="small text-muted">${e.subjectName}</div>
                                            </td>
                                            <td class="fw-semibold">${e.teacherName}</td>
                                            <td>
                                                <div><strong>${e.durationMinutes}</strong> mins</div>
                                                <small class="text-muted">${e.totalMarks} Marks (Pass: ${e.passingMarks})</small>
                                            </td>
                                            <td>
                                                <div class="small"><i class="bi bi-play-circle text-success me-1"></i>${e.startTime}</div>
                                                <div class="small"><i class="bi bi-stop-circle text-danger me-1"></i>${e.endTime}</div>
                                            </td>
                                            <td><span class="badge bg-secondary">${e.questionCount}</span></td>
                                            <td><span class="badge bg-primary">${e.attemptCount}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${e.isActive()}">
                                                        <span class="badge-status active"><i class="bi bi-circle-fill" style="font-size:0.5rem;"></i> Active</span>
                                                    </c:when>
                                                    <c:when test="${e.isUpcoming()}">
                                                        <span class="badge-status upcoming"><i class="bi bi-clock"></i> Upcoming</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status expired">Expired</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/admin/results?examId=${e.id}" 
                                                       class="btn btn-outline-info" title="View Results">
                                                        <i class="bi bi-trophy"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-outline-danger" 
                                                            onclick="confirmDeleteExam(${e.id}, '${e.title}')" title="Delete Exam">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">No examinations created yet.</td>
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
            <form action="${pageContext.request.contextPath}/admin/exams" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="examId" id="delete_examId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger"><i class="bi bi-trash me-2"></i>Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <p>Are you sure you want to permanently delete the examination: <strong id="delete_examTitle"></strong>?</p>
                    <p class="text-danger small mb-0"><i class="bi bi-exclamation-triangle-fill me-1"></i> All associated MCQ questions, student submissions, and results will be permanently removed.</p>
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

