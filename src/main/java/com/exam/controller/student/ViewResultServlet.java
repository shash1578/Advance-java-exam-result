package com.exam.controller.student;

import com.exam.dao.ExamAttemptDAO;
import com.exam.dao.ExamDAO;
import com.exam.dao.ResultDAO;
import com.exam.model.Exam;
import com.exam.model.ExamAttempt;
import com.exam.model.Result;
import com.exam.model.Student;
import com.exam.model.StudentAnswer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewResultServlet", urlPatterns = {"/student/view-result"})
public class ViewResultServlet extends HttpServlet {

    private final ResultDAO resultDAO = new ResultDAO();
    private final ExamAttemptDAO attemptDAO = new ExamAttemptDAO();
    private final ExamDAO examDAO = new ExamDAO();

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
            response.sendRedirect(request.getContextPath() + "/student/results");
            return;
        }

        int attemptId = Integer.parseInt(attemptIdParam.trim());
        ExamAttempt attempt = attemptDAO.findById(attemptId);
        if (attempt == null || attempt.getStudentId() != student.getId()) {
            response.sendRedirect(request.getContextPath() + "/student/results?error=Unauthorized+access+to+result");
            return;
        }

        Result result = resultDAO.findByAttemptId(attemptId);
        if (result == null) {
            response.sendRedirect(request.getContextPath() + "/student/results?error=Result+not+found+or+still+evaluating");
            return;
        }

        Exam exam = examDAO.findById(attempt.getExamId());
        List<StudentAnswer> answers = attemptDAO.getAnswerReviewList(attemptId);

        request.setAttribute("attempt", attempt);
        request.setAttribute("result", result);
        request.setAttribute("exam", exam);
        request.setAttribute("answers", answers);

        request.getRequestDispatcher("/student/view-result.jsp").forward(request, response);
    }
}

