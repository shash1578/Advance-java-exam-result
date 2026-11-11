package com.exam.controller.auth;

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

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String rollNumber = request.getParameter("rollNumber");
        String department = request.getParameter("department");
        String admissionYearStr = request.getParameter("admissionYear");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Basic validation
        if (fullName == null || fullName.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            rollNumber == null || rollNumber.trim().isEmpty() ||
            department == null || department.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All mandatory fields must be filled.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        username = username.trim().toLowerCase();
        email = email.trim().toLowerCase();
        rollNumber = rollNumber.trim().toUpperCase();

        if (userDAO.existsByUsername(username, 0)) {
            request.setAttribute("errorMessage", "Username '" + username + "' is already taken.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.existsByEmail(email, 0)) {
            request.setAttribute("errorMessage", "Email '" + email + "' is already registered.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (studentDAO.existsByRollNumber(rollNumber, 0)) {
            request.setAttribute("errorMessage", "Roll Number '" + rollNumber + "' is already registered.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        int admissionYear = Calendar.getInstance().get(Calendar.YEAR);
        try {
            if (admissionYearStr != null && !admissionYearStr.trim().isEmpty()) {
                admissionYear = Integer.parseInt(admissionYearStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        Student student = new Student();
        student.setFullName(fullName.trim());
        student.setUsername(username);
        student.setEmail(email);
        student.setRollNumber(rollNumber);
        student.setDepartment(department.trim());
        student.setAdmissionYear(admissionYear);
        student.setPhone(phone != null ? phone.trim() : null);
        student.setActive(true);

        boolean success = studentDAO.createStudent(student, password);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/login?msg=Registration+successful!+Please+log+in+with+your+credentials.");
        } else {
            request.setAttribute("errorMessage", "An error occurred while creating your account. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}

