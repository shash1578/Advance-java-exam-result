package com.exam.controller.student;

import com.exam.dao.ExamAttemptDAO;
import com.exam.dao.ExamDAO;
import com.exam.dao.ResultDAO;
import com.exam.dao.StudentDAO;
import com.exam.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DownloadMarksheetServlet", urlPatterns = {"/student/download-marksheet", "/admin/download-marksheet"})
public class DownloadMarksheetServlet extends HttpServlet {

    private final ResultDAO resultDAO = new ResultDAO();
    private final ExamAttemptDAO attemptDAO = new ExamAttemptDAO();
    private final ExamDAO examDAO = new ExamDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String attemptIdParam = request.getParameter("attemptId");
        if (attemptIdParam == null || attemptIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing attemptId");
            return;
        }

        int attemptId = Integer.parseInt(attemptIdParam.trim());
        ExamAttempt attempt = attemptDAO.findById(attemptId);
        if (attempt == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Attempt not found");
            return;
        }

        // Security check: Only the student who took it, a teacher, or admin can access
        if (currentUser.isStudent()) {
            Student student = (Student) session.getAttribute("currentStudent");
            if (student == null || attempt.getStudentId() != student.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized access to marksheet");
                return;
            }
        }

        Result result = resultDAO.findByAttemptId(attemptId);
        if (result == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Result not generated yet");
            return;
        }

        Exam exam = examDAO.findById(attempt.getExamId());
        Student student = studentDAO.findById(attempt.getStudentId());
        List<StudentAnswer> answers = attemptDAO.getAnswerReviewList(attemptId);

        request.setAttribute("attempt", attempt);
        request.setAttribute("result", result);
        request.setAttribute("exam", exam);
        request.setAttribute("student", student);
        request.setAttribute("answers", answers);

        request.getRequestDispatcher("/student/marksheet.jsp").forward(request, response);
    }
}

