package com.exam.controller.admin;

import com.exam.dao.ResultDAO;
import com.exam.dao.StudentDAO;
import com.exam.model.Student;
import com.exam.model.StudentPerformance;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminStudentPerformanceServlet", urlPatterns = {"/admin/student-performance"})
public class AdminStudentPerformanceServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String studentIdParam = request.getParameter("studentId");
        String rollNumberParam = request.getParameter("rollNumber");

        Student targetStudent = null;
        if (studentIdParam != null && !studentIdParam.trim().isEmpty()) {
            try {
                int studentId = Integer.parseInt(studentIdParam.trim());
                targetStudent = studentDAO.findById(studentId);
            } catch (NumberFormatException ignored) {}
        } else if (rollNumberParam != null && !rollNumberParam.trim().isEmpty()) {
            targetStudent = studentDAO.findByRollNumber(rollNumberParam.trim());
        }

        List<Student> allStudents = studentDAO.findAll();
        request.setAttribute("allStudents", allStudents);

        if (targetStudent != null) {
            StudentPerformance performance = resultDAO.getStudentPerformance(targetStudent.getId());
            request.setAttribute("performance", performance);
            request.setAttribute("selectedStudent", targetStudent);
        }

        request.getRequestDispatcher("/admin/student-performance.jsp").forward(request, response);
    }
}

