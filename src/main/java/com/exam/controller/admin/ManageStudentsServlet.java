package com.exam.controller.admin;

import com.exam.dao.StudentDAO;
import com.exam.dao.UserDAO;
import com.exam.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Calendar;
import java.util.List;

@WebServlet(name = "ManageStudentsServlet", urlPatterns = {"/admin/students"})
public class ManageStudentsServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        List<Student> students;
        if (search != null && !search.trim().isEmpty()) {
            students = studentDAO.searchStudents(search.trim());
            request.setAttribute("searchQuery", search.trim());
        } else {
            students = studentDAO.findAll();
        }

        request.setAttribute("students", students);
        request.getRequestDispatcher("/admin/students.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "add";

        switch (action) {
            case "add":
                handleAddStudent(request, response);
                break;
            case "edit":
                handleEditStudent(request, response);
                break;
            case "delete":
                handleDeleteStudent(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/students");
                break;
        }
    }

    private void handleAddStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String rollNumber = request.getParameter("rollNumber");
        String department = request.getParameter("department");
        String admissionYearStr = request.getParameter("admissionYear");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        if (fullName == null || username == null || email == null || rollNumber == null || password == null ||
            fullName.trim().isEmpty() || username.trim().isEmpty() || email.trim().isEmpty() || rollNumber.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=All+fields+are+required");
            return;
        }

        username = username.trim().toLowerCase();
        email = email.trim().toLowerCase();
        rollNumber = rollNumber.trim().toUpperCase();

        if (userDAO.existsByUsername(username, 0)) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Username+already+taken");
            return;
        }
        if (userDAO.existsByEmail(email, 0)) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Email+already+exists");
            return;
        }
        if (studentDAO.existsByRollNumber(rollNumber, 0)) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Roll+number+already+exists");
            return;
        }

        int admissionYear = Calendar.getInstance().get(Calendar.YEAR);
        try {
            if (admissionYearStr != null && !admissionYearStr.trim().isEmpty()) {
                admissionYear = Integer.parseInt(admissionYearStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        Student s = new Student();
        s.setFullName(fullName.trim());
        s.setUsername(username);
        s.setEmail(email);
        s.setRollNumber(rollNumber);
        s.setDepartment(department != null ? department.trim() : "General");
        s.setAdmissionYear(admissionYear);
        s.setPhone(phone != null ? phone.trim() : "");
        s.setActive(true);

        boolean created = studentDAO.createStudent(s, password.trim());
        if (created) {
            response.sendRedirect(request.getContextPath() + "/admin/students?msg=Student+added+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Failed+to+add+student");
        }
    }

    private void handleEditStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        Student s = studentDAO.findById(studentId);
        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Student+not+found");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String rollNumber = request.getParameter("rollNumber");
        String department = request.getParameter("department");
        String admissionYearStr = request.getParameter("admissionYear");
        String phone = request.getParameter("phone");
        String activeStr = request.getParameter("active");
        String newPassword = request.getParameter("newPassword");

        email = email.trim().toLowerCase();
        rollNumber = rollNumber.trim().toUpperCase();

        if (userDAO.existsByEmail(email, s.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Email+already+exists");
            return;
        }
        if (studentDAO.existsByRollNumber(rollNumber, s.getId())) {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Roll+number+already+exists");
            return;
        }

        s.setFullName(fullName.trim());
        s.setEmail(email);
        s.setRollNumber(rollNumber);
        s.setDepartment(department.trim());
        s.setPhone(phone != null ? phone.trim() : "");
        s.setActive("true".equalsIgnoreCase(activeStr) || "1".equals(activeStr) || "on".equalsIgnoreCase(activeStr));

        try {
            if (admissionYearStr != null) {
                s.setAdmissionYear(Integer.parseInt(admissionYearStr.trim()));
            }
        } catch (NumberFormatException ignored) {}

        boolean updated = studentDAO.updateStudent(s);
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            userDAO.updatePassword(s.getUserId(), newPassword.trim());
        }

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/students?msg=Student+updated+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Failed+to+update+student");
        }
    }

    private void handleDeleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        boolean deleted = studentDAO.deleteStudent(studentId);
        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/students?msg=Student+deleted+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/students?error=Failed+to+delete+student");
        }
    }
}

