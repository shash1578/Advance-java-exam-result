package com.exam.controller.student;

import com.exam.dao.ExamAttemptDAO;
import com.exam.dao.ExamDAO;
import com.exam.model.Exam;
import com.exam.model.ExamAttempt;
import com.exam.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "StartExamServlet", urlPatterns = {"/student/start-exam"})
public class StartExamServlet extends HttpServlet {

    private final ExamDAO examDAO = new ExamDAO();
    private final ExamAttemptDAO attemptDAO = new ExamAttemptDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("currentStudent");
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String examIdParam = request.getParameter("examId");
        if (examIdParam == null || examIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }

        int examId = Integer.parseInt(examIdParam.trim());
        Exam exam = examDAO.findById(examId);
        if (exam == null || !exam.isPublished() || !exam.isActive()) {
            response.sendRedirect(request.getContextPath() + "/student/exams?error=Examination+is+currently+unavailable");
            return;
        }

        // Check if an in-progress attempt already exists
        ExamAttempt activeAttempt = attemptDAO.findActiveAttempt(examId, student.getId());
        if (activeAttempt != null) {
            response.sendRedirect(request.getContextPath() + "/student/exam?attemptId=" + activeAttempt.getId());
            return;
        }

        // Check multiple attempts rule
        if (!exam.isAllowMultipleAttempts() && attemptDAO.hasStudentCompletedExam(examId, student.getId())) {
            response.sendRedirect(request.getContextPath() + "/student/exams?error=You+have+already+attempted+this+examination.");
            return;
        }

        // Start new attempt
        int attemptId = attemptDAO.createAttempt(examId, student.getId());
        if (attemptId > 0) {
            response.sendRedirect(request.getContextPath() + "/student/exam?attemptId=" + attemptId);
        } else {
            response.sendRedirect(request.getContextPath() + "/student/exams?error=Failed+to+start+examination.+Please+try+again.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}

