package com.exam.controller.student;

import com.exam.dao.ExamAttemptDAO;
import com.exam.dao.ExamDAO;
import com.exam.dao.QuestionDAO;
import com.exam.model.Exam;
import com.exam.model.ExamAttempt;
import com.exam.model.Question;
import com.exam.model.Student;
import com.exam.util.DateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ExamEngineServlet", urlPatterns = {"/student/exam"})
public class ExamEngineServlet extends HttpServlet {

    private final ExamAttemptDAO attemptDAO = new ExamAttemptDAO();
    private final ExamDAO examDAO = new ExamDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("currentStudent");
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String attemptIdParam = request.getParameter("attemptId");
        if (attemptIdParam == null || attemptIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }

        int attemptId = Integer.parseInt(attemptIdParam.trim());
        ExamAttempt attempt = attemptDAO.findById(attemptId);

        // Security check: Verify attempt belongs to current student
        if (attempt == null || attempt.getStudentId() != student.getId()) {
            response.sendRedirect(request.getContextPath() + "/student/exams?error=Unauthorized+access+to+examination");
            return;
        }

        // If already submitted, redirect to result page
        if (attempt.getStatus() == ExamAttempt.AttemptStatus.SUBMITTED) {
            response.sendRedirect(request.getContextPath() + "/student/view-result?attemptId=" + attemptId);
            return;
        }

        Exam exam = examDAO.findById(attempt.getExamId());
        if (exam == null) {
            response.sendRedirect(request.getContextPath() + "/student/exams?error=Exam+not+found");
            return;
        }

        // SERVER-SIDE TIMER ENFORCEMENT:
        // Calculate remaining seconds: (startTime + duration) - currentTime
        long remainingSeconds = DateUtil.calculateRemainingSeconds(attempt.getStartTime(), exam.getDurationMinutes());
        if (remainingSeconds <= 0) {
            // Server-side timeout! Automatically submit the attempt
            request.getRequestDispatcher("/student/submit-exam?attemptId=" + attemptId + "&autoSubmit=true").forward(request, response);
            return;
        }

        // Load sanitized questions (NO correct answers or explanations exposed!)
        // Merges existing student answers from DB
        List<Question> questions = questionDAO.findSanitizedForStudent(exam.getId(), attemptId, exam.isRandomizeQuestions());

        if (questions.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/exams?error=This+exam+does+not+contain+any+questions+yet.");
            return;
        }

        // Calculate counts for palette
        int answeredCount = 0;
        int reviewCount = 0;
        for (Question q : questions) {
            if (q.isAnswered()) answeredCount++;
            if (q.isMarkedForReview()) reviewCount++;
        }
        int unansweredCount = questions.size() - answeredCount;

        request.setAttribute("attempt", attempt);
        request.setAttribute("exam", exam);
        request.setAttribute("questions", questions);
        request.setAttribute("remainingSeconds", remainingSeconds);
        request.setAttribute("answeredCount", answeredCount);
        request.setAttribute("unansweredCount", unansweredCount);
        request.setAttribute("reviewCount", reviewCount);

        request.getRequestDispatcher("/student/exam-engine.jsp").forward(request, response);
    }
}

