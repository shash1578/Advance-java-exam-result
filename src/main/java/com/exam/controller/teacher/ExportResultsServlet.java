package com.exam.controller.teacher;

import com.exam.dao.ExamDAO;
import com.exam.dao.ResultDAO;
import com.exam.model.Exam;
import com.exam.model.Result;
import com.exam.util.CSVExportUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "ExportResultsServlet", urlPatterns = {"/teacher/export-csv", "/admin/export-csv"})
public class ExportResultsServlet extends HttpServlet {

    private final ResultDAO resultDAO = new ResultDAO();
    private final ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String examIdParam = request.getParameter("examId");
        if (examIdParam == null || examIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing examId parameter");
            return;
        }

        int examId = Integer.parseInt(examIdParam.trim());
        Exam exam = examDAO.findById(examId);
        if (exam == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Exam not found");
            return;
        }

        List<Result> results = resultDAO.findByExamId(examId);

        String filename = "Exam_Results_" + exam.getTitle().replaceAll("[^a-zA-Z0-9.-]", "_") + ".csv";
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        PrintWriter writer = response.getWriter();
        CSVExportUtil.exportResultsToCSV(writer, results, exam.getTitle());
        writer.flush();
    }
}

