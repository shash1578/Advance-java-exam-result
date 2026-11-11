package com.exam.controller.auth;

import com.exam.dao.StudentDAO;
import com.exam.dao.TeacherDAO;
import com.exam.dao.UserDAO;
import com.exam.model.Student;
import com.exam.model.Teacher;
import com.exam.model.User;
import com.exam.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/change-password"})
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final TeacherDAO teacherDAO = new TeacherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Refresh user model from DB
        User refreshed = userDAO.findById(currentUser.getId());
        session.setAttribute("currentUser", refreshed);

        if (refreshed.isStudent()) {
            Student s = studentDAO.findByUserId(refreshed.getId());
            request.setAttribute("studentProfile", s);
        } else if (refreshed.isTeacher()) {
            Teacher t = teacherDAO.findByUserId(refreshed.getId());
            request.setAttribute("teacherProfile", t);
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        if ("/change-password".equals(path)) {
            handleChangePassword(request, response, currentUser);
        } else {
            handleUpdateProfile(request, response, currentUser);
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Full Name and Email are required.");
            doGet(request, response);
            return;
        }

        email = email.trim().toLowerCase();
        if (userDAO.existsByEmail(email, currentUser.getId())) {
            request.setAttribute("errorMessage", "Email is already taken by another user.");
            doGet(request, response);
            return;
        }

        currentUser.setFullName(fullName.trim());
        currentUser.setEmail(email);
        currentUser.setPhone(phone != null ? phone.trim() : null);

        boolean updated = userDAO.updateUser(currentUser);
        if (updated) {
            request.getSession().setAttribute("currentUser", currentUser);
            request.setAttribute("successMessage", "Profile updated successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to update profile.");
        }
        doGet(request, response);
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        User dbUser = userDAO.findById(currentUser.getId());
        if (!PasswordUtil.verifyPassword(currentPassword, dbUser.getPasswordHash())) {
            request.setAttribute("pwdErrorMessage", "Current password is incorrect.");
            doGet(request, response);
            return;
        }

        if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("pwdErrorMessage", "New password must be at least 6 characters.");
            doGet(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("pwdErrorMessage", "New passwords do not match.");
            doGet(request, response);
            return;
        }

        boolean updated = userDAO.updatePassword(currentUser.getId(), newPassword);
        if (updated) {
            request.setAttribute("pwdSuccessMessage", "Password updated successfully!");
        } else {
            request.setAttribute("pwdErrorMessage", "Failed to update password.");
        }
        doGet(request, response);
    }
}

