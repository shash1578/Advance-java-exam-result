package com.exam.controller.student;

import com.exam.dao.ExamAttemptDAO;
import com.exam.dao.ExamDAO;
import com.exam.dao.QuestionDAO;
import com.exam.dao.ResultDAO;
import com.exam.model.*;
import com.exam.util.GradeUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SubmitExamServlet", urlPatterns = {"/student/submit-exam"})
public class SubmitExamServlet extends HttpServlet {

    private final ExamAttemptDAO attemptDAO = new ExamAttemptDAO();
    private final ExamDAO examDAO = new ExamDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processSubmission(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processSubmission(request, response);
    }

    private synchronized void processSubmission(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("currentStudent") : null;
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

        // Security check
        if (attempt == null || attempt.getStudentId() != student.getId()) {
            response.sendRedirect(request.getContextPath() + "/student/exams?error=Unauthorized+submission");
            return;
        }

        // Check if already submitted (idempotency guard)
        if (attempt.getStatus() == ExamAttempt.AttemptStatus.SUBMITTED) {
            response.sendRedirect(request.getContextPath() + "/student/view-result?attemptId=" + attemptId);
            return;
        }

        Exam exam = examDAO.findById(attempt.getExamId());
        if (exam == null) {
            response.sendRedirect(request.getContextPath() + "/student/exams?error=Exam+not+found");
            return;
        }

        // If any answers were passed in the form submission directly, save them
        List<Question> examQuestions = questionDAO.findByExamId(exam.getId());
        for (Question q : examQuestions) {
            String formOption = request.getParameter("q_" + q.getId());
            if (formOption != null && !formOption.trim().isEmpty()) {
                attemptDAO.saveAnswer(attemptId, q.getId(), formOption.trim().toUpperCase(), false);
            }
        }

        // Fetch all saved student answers
        List<StudentAnswer> savedAnswers = attemptDAO.getSavedAnswers(attemptId);
        Map<Integer, StudentAnswer> answerMap = new HashMap<>();
        for (StudentAnswer sa : savedAnswers) {
            answerMap.put(sa.getQuestionId(), sa);
        }

        int totalQuestions = examQuestions.size();
        int correctCount = 0;
        int incorrectCount = 0;
        int unattemptedCount = 0;
        double obtainedMarks = 0.0;
        double examTotalMarks = 0.0;
        double negativeRate = exam.getNegativeMarkingPerQuestion();

        for (Question q : examQuestions) {
            examTotalMarks += q.getMarks();
            StudentAnswer sa = answerMap.get(q.getId());

            if (sa != null && sa.getSelectedOption() != null && !sa.getSelectedOption().trim().isEmpty()) {
                String studentChoice = sa.getSelectedOption().trim().toUpperCase();
                String correctChoice = q.getCorrectOption().trim().toUpperCase();

                if (studentChoice.equals(correctChoice)) {
                    correctCount++;
                    double marks = q.getMarks();
                    obtainedMarks += marks;
                    attemptDAO.updateAnswerEvaluation(attemptId, q.getId(), true, marks);
                } else {
                    incorrectCount++;
                    double penalty = -negativeRate;
                    obtainedMarks += penalty;
                    attemptDAO.updateAnswerEvaluation(attemptId, q.getId(), false, penalty);
                }
            } else {
                unattemptedCount++;
                // Unattempted: 0 marks
                attemptDAO.updateAnswerEvaluation(attemptId, q.getId(), false, 0.00);
            }
        }

        // Ensure obtained marks is not less than zero
        if (obtainedMarks < 0.0) {
            obtainedMarks = 0.0;
        }

        // Fallback for exam total marks if not explicitly configured
        if (examTotalMarks <= 0) {
            examTotalMarks = exam.getTotalMarks();
        }

        double percentage = (examTotalMarks > 0) ? (obtainedMarks / examTotalMarks) * 100.0 : 0.0;
        percentage = Math.round(percentage * 100.0) / 100.0;

        String grade = GradeUtil.calculateGrade(percentage);
        String status = GradeUtil.calculateStatus(obtainedMarks, exam.getPassingMarks());

        // Create Result entity
        Result result = new Result();
        result.setAttemptId(attemptId);
        result.setExamId(exam.getId());
        result.setStudentId(student.getId());
        result.setTotalQuestions(totalQuestions);
        result.setCorrectAnswers(correctCount);
        result.setIncorrectAnswers(incorrectCount);
        result.setUnattempted(unattemptedCount);
        result.setTotalMarks(examTotalMarks);
        result.setObtainedMarks(obtainedMarks);
        result.setPercentage(percentage);
        result.setGrade(grade);
        result.setStatus(status);

        // Save result in DB
        resultDAO.saveResult(result);

        // Finalize Attempt
        attemptDAO.finalizeAttempt(attemptId, obtainedMarks, ExamAttempt.AttemptStatus.SUBMITTED);

        // Redirect student to Result page
        response.sendRedirect(request.getContextPath() + "/student/view-result?attemptId=" + attemptId + "&submitted=true");
    }
}

