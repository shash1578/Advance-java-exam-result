<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Manage Students - Online Examination System" />
<c:set var="activePage" value="students" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/admin-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title"><i class="bi bi-people-fill text-primary me-2"></i>Student Management</h1>
            </div>
            <div class="header-right">
                <button type="button" class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addStudentModal">
                    <i class="bi bi-person-plus-fill"></i> Add Student
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

            <!-- Search and Filter Bar -->
            <div class="card-modern mb-4">
                <div class="card-body-modern py-3">
                    <form action="${pageContext.request.contextPath}/admin/students" method="get" class="row g-2 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                                <input type="text" class="form-control" name="search" value="${searchQuery}" 
                                       placeholder="Search by student name, roll number, or department..." data-table-search="#studentsTable">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-outline-primary w-100 fw-semibold">
                                Search
                            </button>
                        </div>
                        <c:if test="${not empty searchQuery}">
                            <div class="col-md-2">
                                <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-outline-secondary w-100">
                                    Clear Filter
                                </a>
                            </div>
                        </c:if>
                    </form>
                </div>
            </div>

            <!-- Students Table -->
            <div class="card-modern">
                <div class="card-header-modern">
                    <h2 class="card-title">Registered Students (${students.size()})</h2>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern" id="studentsTable">
                        <thead>
                            <tr>
                                <th>Roll Number</th>
                                <th>Full Name</th>
                                <th>Username / Email</th>
                                <th>Department</th>
                                <th>Batch</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty students}">
                                    <c:forEach var="s" items="${students}">
                                        <tr>
                                            <td><span class="badge bg-dark fs-6">${s.rollNumber}</span></td>
                                            <td class="fw-bold text-dark">${s.fullName}</td>
                                            <td>
                                                <div><code>${s.username}</code></div>
                                                <small class="text-muted">${s.email}</small>
                                            </td>
                                            <td>${s.department}</td>
                                            <td>${s.admissionYear}</td>
                                            <td>
                                                <span class="badge ${s.active ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'}">
                                                    ${s.active ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/admin/student-performance?studentId=${s.id}" 
                                                       class="btn btn-outline-info" title="View Student Analytics">
                                                        <i class="bi bi-graph-up"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-outline-primary" 
                                                            onclick="openEditStudentModal(${s.id}, '${s.fullName}', '${s.rollNumber}', '${s.email}', '${s.department}', ${s.admissionYear}, '${s.phone}', ${s.active})"
                                                            title="Edit Student">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-outline-danger" 
                                                            onclick="confirmDeleteStudent(${s.id}, '${s.fullName}')" title="Delete Student">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">No student records match your query.</td>
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

<!-- Add Student Modal -->
<div class="modal fade" id="addStudentModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/students" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-person-plus-fill text-primary me-2"></i>Add New Student</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Full Name *</label>
                            <input type="text" class="form-control" name="fullName" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Roll Number *</label>
                            <input type="text" class="form-control" name="rollNumber" placeholder="e.g. CS2024-010" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Username *</label>
                            <input type="text" class="form-control" name="username" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email Address *</label>
                            <input type="email" class="form-control" name="email" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Department *</label>
                            <input type="text" class="form-control" name="department" placeholder="e.g. Computer Science" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Admission Year</label>
                            <input type="number" class="form-control" name="admissionYear" value="2024">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">Phone</label>
                            <input type="text" class="form-control" name="phone">
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-semibold">Initial Password *</label>
                            <input type="password" class="form-control" name="password" minlength="6" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom">Create Student Account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Student Modal -->
<div class="modal fade" id="editStudentModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/students" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="studentId" id="edit_studentId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square text-primary me-2"></i>Edit Student Account</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Full Name *</label>
                            <input type="text" class="form-control" id="edit_fullName" name="fullName" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Roll Number *</label>
                            <input type="text" class="form-control" id="edit_rollNumber" name="rollNumber" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email Address *</label>
                            <input type="email" class="form-control" id="edit_email" name="email" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Department *</label>
                            <input type="text" class="form-control" id="edit_department" name="department" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Admission Year</label>
                            <input type="number" class="form-control" id="edit_admissionYear" name="admissionYear">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Phone</label>
                            <input type="text" class="form-control" id="edit_phone" name="phone">
                        </div>
                        <div class="col-md-4">
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
                    <button type="submit" class="btn btn-primary-custom">Update Student</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Student Modal -->
<div class="modal fade" id="deleteStudentModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/students" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="studentId" id="delete_studentId">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold text-danger"><i class="bi bi-trash me-2"></i>Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <p>Are you sure you want to permanently delete the student account for <strong id="delete_studentName"></strong>?</p>
                    <p class="text-danger small mb-0"><i class="bi bi-exclamation-triangle-fill me-1"></i> This will also remove all examination attempts and results associated with this student.</p>
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
    function openEditStudentModal(id, name, roll, email, dept, year, phone, active) {
        document.getElementById('edit_studentId').value = id;
        document.getElementById('edit_fullName').value = name;
        document.getElementById('edit_rollNumber').value = roll;
        document.getElementById('edit_email').value = email;
        document.getElementById('edit_department').value = dept;
        document.getElementById('edit_admissionYear').value = year;
        document.getElementById('edit_phone').value = phone || '';
        document.getElementById('edit_active').value = active ? 'true' : 'false';

        new bootstrap.Modal(document.getElementById('editStudentModal')).show();
    }

    function confirmDeleteStudent(id, name) {
        document.getElementById('delete_studentId').value = id;
        document.getElementById('delete_studentName').textContent = name;
        new bootstrap.Modal(document.getElementById('deleteStudentModal')).show();
    }
</script>

<jsp:include page="/includes/footer.jsp" />

