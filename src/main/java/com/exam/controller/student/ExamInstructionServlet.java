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

@WebServlet(name = "ExamInstructionServlet", urlPatterns = {"/student/exam-instructions"})
public class ExamInstructionServlet extends HttpServlet {

    private final ExamDAO examDAO = new ExamDAO();
    private final ExamAttemptDAO attemptDAO = new ExamAttemptDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
        if (exam == null || !exam.isPublished()) {
            response.sendRedirect(request.getContextPath() + "/student/exams?error=Exam+not+found+or+unavailable");
            return;
        }

        // Check if student has an in-progress attempt to resume
        ExamAttempt activeAttempt = attemptDAO.findActiveAttempt(examId, student.getId());
        if (activeAttempt != null) {
            response.sendRedirect(request.getContextPath() + "/student/exam?attemptId=" + activeAttempt.getId());
            return;
        }

        // Check if student has already completed this exam and multiple attempts are disallowed
        if (!exam.isAllowMultipleAttempts() && attemptDAO.hasStudentCompletedExam(examId, student.getId())) {
            response.sendRedirect(request.getContextPath() + "/student/exams?error=You+have+already+attempted+this+examination.+Multiple+attempts+are+not+permitted.");
            return;
        }

        // Check exam schedule window
        if (!exam.isActive()) {
            if (exam.isUpcoming()) {
                response.sendRedirect(request.getContextPath() + "/student/exams?error=This+examination+has+not+started+yet.");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/exams?error=This+examination+has+expired.");
            }
            return;
        }

        request.setAttribute("exam", exam);
        request.getRequestDispatcher("/student/exam-instructions.jsp").forward(request, response);
    }
}

