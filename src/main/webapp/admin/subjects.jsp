<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Manage Subjects - Online Examination System" />
<c:set var="activePage" value="subjects" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-journal-bookmark-fill text-primary me-2"></i>Subject Management</h1>
            </div>
            <div class="header-right">
                <button type="button" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addSubjectModal">
                    <i class="bi bi-plus-circle-fill"></i> Add Subject
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

            <!-- Search Filter Bar -->
            <div class="card-modern mb-4">
                <div class="card-body-modern py-3">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control" placeholder="Search subjects by code or title..." data-table-search="#subjectsTable">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Subjects Table -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title">Curriculum Subjects (${subjects.size()})</h2>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern" id="subjectsTable">
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Subject Name</th>
                                <th>Description</th>
                                <th>Exams Hosted</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty subjects}">
                                    <c:forEach var="s" items="${subjects}">
                                        <tr>
                                            <td><span class="badge bg-dark fs-6">${s.subjectCode}</span></td>
                                            <td class="fw-bold text-dark">${s.subjectName}</td>
                                            <td class="text-muted" style="max-width: 320px;">
                                                ${empty s.description ? 'No description provided' : s.description}
                                            </td>
                                            <td>
                                                <span class="badge bg-primary-subtle text-primary fw-bold">
                                                    ${s.totalExams} Exams
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <button type="button" class="btn btn-outline-primary" 
                                                            onclick="openEditSubjectModal(${s.id}, '${s.subjectCode}', '${s.subjectName}', '${s.description}')"
                                                            title="Edit Subject">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-outline-danger" 
                                                            onclick="confirmDeleteSubject(${s.id}, '${s.subjectName}')" title="Delete Subject">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">No subjects found.</td>
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

<!-- Add Subject Modal -->
<div class="modal fade" id="addSubjectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/subjects" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-journal-plus text-primary me-2"></i>Add New Subject</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Subject Code *</label>
                        <input type="text" class="form-control" name="subjectCode" placeholder="e.g. CS106" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Subject Name *</label>
                        <input type="text" class="form-control" name="subjectName" placeholder="e.g. Cloud Computing & DevOps" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea class="form-control" name="description" rows="3" placeholder="Brief subject syllabus and overview..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom">Add Subject</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Subject Modal -->
<div class="modal fade" id="editSubjectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/subjects" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="subjectId" id="edit_subjectId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square text-primary me-2"></i>Edit Subject</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Subject Code *</label>
                        <input type="text" class="form-control" id="edit_subjectCode" name="subjectCode" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Subject Name *</label>
                        <input type="text" class="form-control" id="edit_subjectName" name="subjectName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea class="form-control" id="edit_description" name="description" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom">Update Subject</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Subject Modal -->
<div class="modal fade" id="deleteSubjectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/subjects" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="subjectId" id="delete_subjectId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger"><i class="bi bi-trash me-2"></i>Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <p>Are you sure you want to permanently delete subject: <strong id="delete_subjectName"></strong>?</p>
                    <p class="text-danger small mb-0"><i class="bi bi-exclamation-triangle-fill me-1"></i> All associated examinations and questions under this subject will also be deleted.</p>
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
    function openEditSubjectModal(id, code, name, desc) {
        document.getElementById('edit_subjectId').value = id;
        document.getElementById('edit_subjectCode').value = code;
        document.getElementById('edit_subjectName').value = name;
        document.getElementById('edit_description').value = desc || '';
        new bootstrap.Modal(document.getElementById('editSubjectModal')).show();
    }

    function confirmDeleteSubject(id, name) {
        document.getElementById('delete_subjectId').value = id;
        document.getElementById('delete_subjectName').textContent = name;
        new bootstrap.Modal(document.getElementById('deleteSubjectModal')).show();
    }
</script>

<jsp:include page="/includes/footer.jsp" />

