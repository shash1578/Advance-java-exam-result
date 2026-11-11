package com.exam.controller.admin;

import com.exam.dao.ExamDAO;
import com.exam.dao.ResultDAO;
import com.exam.model.Exam;
import com.exam.model.Result;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminResultsServlet", urlPatterns = {"/admin/results"})
public class AdminResultsServlet extends HttpServlet {

    private final ResultDAO resultDAO = new ResultDAO();
    private final ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String examIdParam = request.getParameter("examId");
        List<Result> results;
        if (examIdParam != null && !examIdParam.trim().isEmpty()) {
            try {
                int examId = Integer.parseInt(examIdParam.trim());
                results = resultDAO.findByExamId(examId);
                request.setAttribute("selectedExamId", examId);
            } catch (NumberFormatException e) {
                results = resultDAO.findAll();
            }
        } else {
            results = resultDAO.findAll();
        }

        List<Exam> exams = examDAO.findAll();
        request.setAttribute("results", results);
        request.setAttribute("exams", exams);
        request.getRequestDispatcher("/admin/results.jsp").forward(request, response);
    }
}

