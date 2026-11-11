package com.exam.controller.student;

import com.exam.dao.ResultDAO;
import com.exam.model.Result;
import com.exam.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentResultsServlet", urlPatterns = {"/student/results"})
public class StudentResultsServlet extends HttpServlet {

    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("currentStudent");
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Result> results = resultDAO.findByStudentId(student.getId());
        request.setAttribute("results", results);
        request.getRequestDispatcher("/student/results.jsp").forward(request, response);
    }
}

