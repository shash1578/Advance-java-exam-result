package com.exam.controller.admin;

import com.exam.dao.TeacherDAO;
import com.exam.dao.UserDAO;
import com.exam.model.Teacher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageTeachersServlet", urlPatterns = {"/admin/teachers"})
public class ManageTeachersServlet extends HttpServlet {

    private final TeacherDAO teacherDAO = new TeacherDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Teacher> teachers = teacherDAO.findAll();
        request.setAttribute("teachers", teachers);
        request.getRequestDispatcher("/admin/teachers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "add";

        switch (action) {
            case "add":
                handleAddTeacher(request, response);
                break;
            case "edit":
                handleEditTeacher(request, response);
                break;
            case "delete":
                handleDeleteTeacher(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/teachers");
                break;
        }
    }

    private void handleAddTeacher(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String employeeId = request.getParameter("employeeId");
        String department = request.getParameter("department");
        String qualification = request.getParameter("qualification");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        if (fullName == null || username == null || email == null || employeeId == null || password == null ||
            fullName.trim().isEmpty() || username.trim().isEmpty() || email.trim().isEmpty() || employeeId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?error=All+mandatory+fields+are+required");
            return;
        }

        username = username.trim().toLowerCase();
        email = email.trim().toLowerCase();
        employeeId = employeeId.trim().toUpperCase();

        if (userDAO.existsByUsername(username, 0)) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?error=Username+already+taken");
            return;
        }
        if (userDAO.existsByEmail(email, 0)) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?error=Email+already+exists");
            return;
        }
        if (teacherDAO.existsByEmployeeId(employeeId, 0)) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?error=Employee+ID+already+exists");
            return;
        }

        Teacher t = new Teacher();
        t.setFullName(fullName.trim());
        t.setUsername(username);
        t.setEmail(email);
        t.setEmployeeId(employeeId);
        t.setDepartment(department != null ? department.trim() : "General");
        t.setQualification(qualification != null ? qualification.trim() : "");
        t.setPhone(phone != null ? phone.trim() : "");
        t.setActive(true);

        boolean created = teacherDAO.createTeacher(t, password.trim());
        if (created) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?msg=Teacher+added+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?error=Failed+to+add+teacher");
        }
    }

    private void handleEditTeacher(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int teacherId = Integer.parseInt(request.getParameter("teacherId"));
        Teacher t = teacherDAO.findById(teacherId);
        if (t == null) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?error=Teacher+not+found");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String employeeId = request.getParameter("employeeId");
        String department = request.getParameter("department");
        String qualification = request.getParameter("qualification");
        String phone = request.getParameter("phone");
        String activeStr = request.getParameter("active");
        String newPassword = request.getParameter("newPassword");

        email = email.trim().toLowerCase();
        employeeId = employeeId.trim().toUpperCase();

        if (userDAO.existsByEmail(email, t.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?error=Email+already+exists");
            return;
        }
        if (teacherDAO.existsByEmployeeId(employeeId, t.getId())) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?error=Employee+ID+already+exists");
            return;
        }

        t.setFullName(fullName.trim());
        t.setEmail(email);
        t.setEmployeeId(employeeId);
        t.setDepartment(department.trim());
        t.setQualification(qualification != null ? qualification.trim() : "");
        t.setPhone(phone != null ? phone.trim() : "");
        t.setActive("true".equalsIgnoreCase(activeStr) || "1".equals(activeStr) || "on".equalsIgnoreCase(activeStr));

        boolean updated = teacherDAO.updateTeacher(t);
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            userDAO.updatePassword(t.getUserId(), newPassword.trim());
        }

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?msg=Teacher+updated+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?error=Failed+to+update+teacher");
        }
    }

    private void handleDeleteTeacher(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int teacherId = Integer.parseInt(request.getParameter("teacherId"));
        boolean deleted = teacherDAO.deleteTeacher(teacherId);
        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?msg=Teacher+deleted+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?error=Failed+to+delete+teacher");
        }
    }
}

