<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Error - Online Examination Portal" />
<jsp:include page="/includes/header.jsp" />

<div class="d-flex align-items-center justify-content-center min-vh-100 bg-light p-4">
    <div class="text-center p-5 bg-white rounded-4 shadow-sm border" style="max-width: 550px;">
        <div class="display-1 text-danger fw-bold mb-3">
            <i class="bi bi-exclamation-triangle-fill"></i>
        </div>
        <h2 class="fw-bold mb-2">Notice / Encountered Error</h2>
        <p class="text-muted mb-4">
            <c:choose>
                <c:when test="${param.code == '404'}">
                    The requested page or resource could not be found. Please check the URL.
                </c:when>
                <c:when test="${param.code == '403'}">
                    Access Denied. You do not have permission to view the requested resource.
                </c:when>
                <c:otherwise>
                    An unexpected error occurred during processing. Please verify your input or return to the portal.
                </c:otherwise>
            </c:choose>
        </p>

        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary-custom">
                <i class="bi bi-house-door-fill me-1"></i> Return to Portal
            </a>
            <button onclick="window.history.back()" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i> Go Back
            </button>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

