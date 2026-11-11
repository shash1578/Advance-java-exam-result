<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Manage Teachers - Online Examination System" />
<c:set var="activePage" value="teachers" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-person-badge-fill text-primary me-2"></i>Faculty / Teacher Management</h1>
            </div>
            <div class="header-right">
                <button type="button" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addTeacherModal">
                    <i class="bi bi-person-plus-fill"></i> Add Teacher
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
                                <input type="text" class="form-control" placeholder="Filter teachers by name, ID, or department..." data-table-search="#teachersTable">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Teachers Table -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title">Registered Faculty Members (${teachers.size()})</h2>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern" id="teachersTable">
                        <thead>
                            <tr>
                                <th>Employee ID</th>
                                <th>Faculty Name</th>
                                <th>Username / Email</th>
                                <th>Department</th>
                                <th>Qualification</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty teachers}">
                                    <c:forEach var="t" items="${teachers}">
                                        <tr>
                                            <td><span class="badge bg-primary-subtle text-primary fw-bold fs-6">${t.employeeId}</span></td>
                                            <td class="fw-bold text-dark">${t.fullName}</td>
                                            <td>
                                                <div><code>${t.username}</code></div>
                                                <small class="text-muted">${t.email}</small>
                                            </td>
                                            <td>${t.department}</td>
                                            <td><span class="badge bg-light text-dark border">${t.qualification}</span></td>
                                            <td>
                                                <span class="badge ${t.active ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'}">
                                                    ${t.active ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <button type="button" class="btn btn-outline-primary" 
                                                            onclick="openEditTeacherModal(${t.id}, '${t.fullName}', '${t.employeeId}', '${t.email}', '${t.department}', '${t.qualification}', '${t.phone}', ${t.active})"
                                                            title="Edit Teacher">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-outline-danger" 
                                                            onclick="confirmDeleteTeacher(${t.id}, '${t.fullName}')" title="Delete Teacher">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">No teacher accounts found.</td>
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

<!-- Add Teacher Modal -->
<div class="modal fade" id="addTeacherModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/teachers" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-person-plus-fill text-primary me-2"></i>Add New Teacher</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Full Name *</label>
                            <input type="text" class="form-control" name="fullName" placeholder="e.g. Dr. Rajesh Sharma" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Employee ID *</label>
                            <input type="text" class="form-control" name="employeeId" placeholder="e.g. EMP-T105" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Username *</label>
                            <input type="text" class="form-control" name="username" placeholder="e.g. prof.sharma" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email Address *</label>
                            <input type="email" class="form-control" name="email" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Department *</label>
                            <input type="text" class="form-control" name="department" placeholder="e.g. Computer Science" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Qualification</label>
                            <input type="text" class="form-control" name="qualification" placeholder="e.g. Ph.D. in Computer Science">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Phone</label>
                            <input type="text" class="form-control" name="phone">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Initial Password *</label>
                            <input type="password" class="form-control" name="password" minlength="6" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom">Create Teacher Account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Teacher Modal -->
<div class="modal fade" id="editTeacherModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/teachers" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="teacherId" id="edit_teacherId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square text-primary me-2"></i>Edit Teacher Account</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Full Name *</label>
                            <input type="text" class="form-control" id="edit_fullName" name="fullName" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Employee ID *</label>
                            <input type="text" class="form-control" id="edit_employeeId" name="employeeId" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email Address *</label>
                            <input type="email" class="form-control" id="edit_email" name="email" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Department *</label>
                            <input type="text" class="form-control" id="edit_department" name="department" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Qualification</label>
                            <input type="text" class="form-control" id="edit_qualification" name="qualification">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Phone</label>
                            <input type="text" class="form-control" id="edit_phone" name="phone">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Account Status</label>
                            <select class="form-select" id="edit_active" name="active">
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-semibold">Reset Password (leave empty to keep current)</label>
                            <input type="password" class="form-control" name="newPassword" placeholder="Enter new password">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom">Update Teacher</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Teacher Modal -->
<div class="modal fade" id="deleteTeacherModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/teachers" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="teacherId" id="delete_teacherId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger"><i class="bi bi-trash me-2"></i>Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <p>Are you sure you want to permanently delete the teacher account for <strong id="delete_teacherName"></strong>?</p>
                    <p class="text-danger small mb-0"><i class="bi bi-exclamation-triangle-fill me-1"></i> This will also remove all examinations and questions created by this teacher.</p>
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
    function openEditTeacherModal(id, name, empId, email, dept, qual, phone, active) {
        document.getElementById('edit_teacherId').value = id;
        document.getElementById('edit_fullName').value = name;
        document.getElementById('edit_employeeId').value = empId;
        document.getElementById('edit_email').value = email;
        document.getElementById('edit_department').value = dept;
        document.getElementById('edit_qualification').value = qual || '';
        document.getElementById('edit_phone').value = phone || '';
        document.getElementById('edit_active').value = active ? 'true' : 'false';

        new bootstrap.Modal(document.getElementById('editTeacherModal')).show();
    }

    function confirmDeleteTeacher(id, name) {
        document.getElementById('delete_teacherId').value = id;
        document.getElementById('delete_teacherName').textContent = name;
        new bootstrap.Modal(document.getElementById('deleteTeacherModal')).show();
    }
</script>

<jsp:include page="/includes/footer.jsp" />

