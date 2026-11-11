package com.exam.filter;

import com.exam.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();
        String path = uri.substring(contextPath.length());

        // Static resources and public endpoints are always allowed
        if (path.startsWith("/assets/") ||
            path.startsWith("/css/") ||
            path.startsWith("/js/") ||
            path.startsWith("/images/") ||
            path.equals("/index.jsp") ||
            path.equals("/") ||
            path.equals("/login") ||
            path.equals("/login.jsp") ||
            path.equals("/register") ||
            path.equals("/register.jsp") ||
            path.equals("/logout") ||
            path.equals("/error.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // If not logged in, redirect to login page
        if (user == null) {
            response.sendRedirect(contextPath + "/login?error=Please+log+in+to+continue");
            return;
        }

        // Role-based access control
        if (path.startsWith("/admin/") && !user.isAdmin()) {
            sendUnauthorized(request, response, user);
            return;
        }

        if (path.startsWith("/teacher/") && !user.isTeacher()) {
            sendUnauthorized(request, response, user);
            return;
        }

        if (path.startsWith("/student/") && !user.isStudent()) {
            sendUnauthorized(request, response, user);
            return;
        }

        chain.doFilter(request, response);
    }

    private void sendUnauthorized(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String target = request.getContextPath();
        if (user.isAdmin()) {
            target += "/admin/dashboard?error=Access+denied+to+requested+page";
        } else if (user.isTeacher()) {
            target += "/teacher/dashboard?error=Access+denied+to+requested+page";
        } else if (user.isStudent()) {
            target += "/student/dashboard?error=Access+denied+to+requested+page";
        } else {
            target += "/login?error=Access+denied";
        }
        response.sendRedirect(target);
    }

    @Override
    public void destroy() {}
}

