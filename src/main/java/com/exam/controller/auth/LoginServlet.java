package com.exam.controller.auth;

import com.exam.dao.StudentDAO;
import com.exam.dao.TeacherDAO;
import com.exam.dao.UserDAO;
import com.exam.model.Student;
import com.exam.model.Teacher;
import com.exam.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final TeacherDAO teacherDAO = new TeacherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            redirectToDashboard(user, response, request.getContextPath());
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");

        if (identifier == null || identifier.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please provide both username/email and password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(identifier.trim(), password.trim());
        if (user == null) {
            request.setAttribute("errorMessage", "Invalid credentials or inactive account.");
            request.setAttribute("enteredIdentifier", identifier);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("currentUser", user);

        // Store role-specific model object in session
        if (user.isStudent()) {
            Student student = studentDAO.findByUserId(user.getId());
            session.setAttribute("currentStudent", student);
        } else if (user.isTeacher()) {
            Teacher teacher = teacherDAO.findByUserId(user.getId());
            session.setAttribute("currentTeacher", teacher);
        }

        redirectToDashboard(user, response, request.getContextPath());
    }

    private void redirectToDashboard(User user, HttpServletResponse response, String contextPath)
            throws IOException {
        switch (user.getRole()) {
            case ADMIN:
                response.sendRedirect(contextPath + "/admin/dashboard");
                break;
            case TEACHER:
                response.sendRedirect(contextPath + "/teacher/dashboard");
                break;
            case STUDENT:
                response.sendRedirect(contextPath + "/student/dashboard");
                break;
        }
    }
}

