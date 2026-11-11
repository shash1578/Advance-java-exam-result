package com.exam.controller.student;

import com.exam.dao.ExamAttemptDAO;
import com.exam.dao.ExamDAO;
import com.exam.model.Exam;
import com.exam.model.ExamAttempt;
import com.exam.model.Student;
import com.exam.util.DateUtil;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "SaveAnswerServlet", urlPatterns = {"/student/save-answer"})
public class SaveAnswerServlet extends HttpServlet {

    private final ExamAttemptDAO attemptDAO = new ExamAttemptDAO();
    private final ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        JsonObject json = new JsonObject();

        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("currentStudent") : null;
        if (student == null) {
            json.addProperty("success", false);
            json.addProperty("message", "Session expired. Please log in again.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(json.toString());
            return;
        }

        try {
            int attemptId = Integer.parseInt(request.getParameter("attemptId"));
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String selectedOption = request.getParameter("selectedOption");
            String reviewParam = request.getParameter("isMarkedForReview");
            boolean isMarkedForReview = "true".equalsIgnoreCase(reviewParam);

            ExamAttempt attempt = attemptDAO.findById(attemptId);
            if (attempt == null || attempt.getStudentId() != student.getId()) {
                json.addProperty("success", false);
                json.addProperty("message", "Unauthorized attempt access.");
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write(json.toString());
                return;
            }

            if (attempt.getStatus() != ExamAttempt.AttemptStatus.IN_PROGRESS) {
                json.addProperty("success", false);
                json.addProperty("message", "Examination has already been submitted.");
                response.getWriter().write(json.toString());
                return;
            }

            Exam exam = examDAO.findById(attempt.getExamId());
            long remaining = DateUtil.calculateRemainingSeconds(attempt.getStartTime(), exam.getDurationMinutes());
            if (remaining <= 0) {
                json.addProperty("success", false);
                json.addProperty("expired", true);
                json.addProperty("message", "Time has expired! Submitting examination...");
                response.getWriter().write(json.toString());
                return;
            }

            // Save or clear answer
            boolean saved = attemptDAO.saveAnswer(attemptId, questionId, selectedOption, isMarkedForReview);

            json.addProperty("success", saved);
            json.addProperty("questionId", questionId);
            json.addProperty("selectedOption", selectedOption != null ? selectedOption.toUpperCase() : "");
            json.addProperty("isMarkedForReview", isMarkedForReview);
            json.addProperty("remainingSeconds", remaining);

        } catch (Exception e) {
            json.addProperty("success", false);
            json.addProperty("message", "Invalid request parameters: " + e.getMessage());
        }

        response.getWriter().write(json.toString());
    }
}

