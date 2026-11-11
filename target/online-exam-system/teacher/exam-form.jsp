<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.exam.util.DateUtil" %>
<c:set var="isEdit" value="${not empty exam}" />
<c:set var="pageTitle" value="${isEdit ? 'Edit Examination' : 'Create New Examination'} - Online Examination System" />
<c:set var="activePage" value="${isEdit ? 'exams' : 'newExam'}" />
<jsp:include page="/includes/header.jsp" />

<div class="app-wrapper">
    <jsp:include page="/includes/teacher-sidebar.jsp" />

    <main class="app-main">
        <header class="app-header">
            <div class="header-left">
                <h1 class="page-title">
                    <i class="bi ${isEdit ? 'bi-pencil-square' : 'bi-plus-circle-fill'} text-primary me-2"></i>
                    ${isEdit ? 'Edit Examination Settings' : 'Create New Examination'}
                </h1>
            </div>
            <div class="header-right">
                <a href="${pageContext.request.contextPath}/teacher/exams" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back to Exams
                </a>
            </div>
        </header>

        <div class="app-content">
            <div class="card-modern" style="max-width: 900px; margin: 0 auto;">
                <div class="card-header-modern">
                    <h2 class="card-title">${isEdit ? 'Update Examination Properties' : 'Examination Configuration'}</h2>
                </div>
                <div class="card-body-modern p-4">
                    <form action="${pageContext.request.contextPath}/teacher/exams" method="post">
                        <c:if test="${isEdit}">
                            <input type="hidden" name="examId" value="${exam.id}">
                        </c:if>

                        <div class="row g-3">
                            <!-- Title -->
                            <div class="col-12">
                                <label for="title" class="form-label fw-semibold">Examination Title *</label>
                                <input type="text" class="form-control" id="title" name="title" 
                                       value="${isEdit ? exam.title : ''}" 
                                       placeholder="e.g. Advanced Java &amp; Jakarta EE Comprehensive Assessment" required>
                            </div>

                            <!-- Subject Selection -->
                            <div class="col-md-6">
                                <label for="subjectId" class="form-label fw-semibold">Curriculum Subject *</label>
                                <select class="form-select" id="subjectId" name="subjectId" required>
                                    <option value="">-- Choose Subject --</option>
                                    <c:forEach var="sub" items="${subjects}">
                                        <option value="${sub.id}" ${isEdit && exam.subjectId == sub.id ? 'selected' : ''}>
                                            ${sub.subjectCode}: ${sub.subjectName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Duration -->
                            <div class="col-md-3">
                                <label for="durationMinutes" class="form-label fw-semibold">Duration (Minutes) *</label>
                                <input type="number" class="form-control" id="durationMinutes" name="durationMinutes" 
                                       value="${isEdit ? exam.durationMinutes : '30'}" min="5" max="300" required>
                            </div>

                            <!-- Total Marks -->
                            <div class="col-md-3">
                                <label for="totalMarks" class="form-label fw-semibold">Total Marks *</label>
                                <input type="number" class="form-control" id="totalMarks" name="totalMarks" 
                                       value="${isEdit ? exam.totalMarks : '100'}" min="1" required>
                            </div>

                            <!-- Passing Marks -->
                            <div class="col-md-3">
                                <label for="passingMarks" class="form-label fw-semibold">Passing Marks *</label>
                                <input type="number" class="form-control" id="passingMarks" name="passingMarks" 
                                       value="${isEdit ? exam.passingMarks : '40'}" min="1" required>
                            </div>

                            <!-- Negative Marking -->
                            <div class="col-md-3">
                                <label for="negativeMarkingPerQuestion" class="form-label fw-semibold">Negative Marking / Question</label>
                                <input type="number" step="0.25" class="form-control" id="negativeMarkingPerQuestion" name="negativeMarkingPerQuestion" 
                                       value="${isEdit ? exam.negativeMarkingPerQuestion : '0.00'}" min="0">
                            </div>

                            <!-- Schedule Start Time -->
                            <div class="col-md-3">
                                <label for="startTime" class="form-label fw-semibold">Start Date &amp; Time *</label>
                                <input type="datetime-local" class="form-control" id="startTime" name="startTime" 
                                       value="${isEdit ? DateUtil.formatForInput(exam.startTime) : '2026-01-01T09:00'}" required>
                            </div>

                            <!-- Schedule End Time -->
                            <div class="col-md-3">
                                <label for="endTime" class="form-label fw-semibold">End Date &amp; Time *</label>
                                <input type="datetime-local" class="form-control" id="endTime" name="endTime" 
                                       value="${isEdit ? DateUtil.formatForInput(exam.endTime) : '2027-12-31T23:59'}" required>
                            </div>

                            <!-- Description -->
                            <div class="col-12">
                                <label for="description" class="form-label fw-semibold">Short Description / Syllabus Overview</label>
                                <textarea class="form-control" id="description" name="description" rows="2" 
                                          placeholder="Topics covered in this exam...">${isEdit ? exam.description : ''}</textarea>
                            </div>

                            <!-- Instructions -->
                            <div class="col-12">
                                <label for="instructions" class="form-label fw-semibold">Student Exam Instructions</label>
                                <textarea class="form-control" id="instructions" name="instructions" rows="4" 
                                          placeholder="1. Read each question carefully.&#10;2. Timer is enforced on the server.&#10;3. Click Submit when finished.">${isEdit ? exam.instructions : ''}</textarea>
                            </div>

                            <!-- Advanced Configuration Flags -->
                            <div class="col-12 mt-4">
                                <div class="p-3 bg-light rounded-3 border">
                                    <div class="fw-bold mb-2 text-dark">Assessment Policy &amp; Security Options</div>
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <div class="form-check form-switch">
                                                <input class="form-check-input" type="checkbox" id="allowMultipleAttempts" name="allowMultipleAttempts" 
                                                       value="true" ${isEdit && exam.allowMultipleAttempts ? 'checked' : ''}>
                                                <label class="form-check-label fw-semibold" for="allowMultipleAttempts">
                                                    Allow Multiple Attempts
                                                </label>
                                                <small class="text-muted d-block">Students can re-take exam</small>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-check form-switch">
                                                <input class="form-check-input" type="checkbox" id="randomizeQuestions" name="randomizeQuestions" 
                                                       value="true" ${isEdit && exam.randomizeQuestions ? 'checked' : ''}>
                                                <label class="form-check-label fw-semibold" for="randomizeQuestions">
                                                    Randomize Question Order
                                                </label>
                                                <small class="text-muted d-block">Shuffles question sequence</small>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <div class="form-check form-switch">
                                                <input class="form-check-input" type="checkbox" id="published" name="published" 
                                                       value="true" ${!isEdit || exam.published ? 'checked' : ''}>
                                                <label class="form-check-label fw-semibold text-primary" for="published">
                                                    Publish Examination
                                                </label>
                                                <small class="text-muted d-block">Visible to students</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top text-end d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/teacher/exams" class="btn btn-outline-secondary">
                                Cancel
                            </a>
                            <button type="submit" class="btn btn-primary-custom">
                                <i class="bi ${isEdit ? 'bi-check-lg' : 'bi-plus-lg'} me-1"></i>
                                ${isEdit ? 'Save Changes' : 'Create Exam &amp; Add Questions'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/includes/footer.jsp" />

