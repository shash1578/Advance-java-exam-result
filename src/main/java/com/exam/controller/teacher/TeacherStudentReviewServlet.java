package com.exam.controller.teacher;

import com.exam.dao.ExamAttemptDAO;
import com.exam.dao.ExamDAO;
import com.exam.dao.ResultDAO;
import com.exam.model.Exam;
import com.exam.model.ExamAttempt;
import com.exam.model.Result;
import com.exam.model.StudentAnswer;
import com.exam.model.Teacher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "TeacherStudentReviewServlet", urlPatterns = {"/teacher/student-review"})
public class TeacherStudentReviewServlet extends HttpServlet {

    private final ExamAttemptDAO attemptDAO = new ExamAttemptDAO();
    private final ExamDAO examDAO = new ExamDAO();
    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Teacher teacher = (Teacher) session.getAttribute("currentTeacher");
        if (teacher == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String attemptIdParam = request.getParameter("attemptId");
        if (attemptIdParam == null || attemptIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/teacher/attempts");
            return;
        }

        int attemptId = Integer.parseInt(attemptIdParam.trim());
        ExamAttempt attempt = attemptDAO.findById(attemptId);
        if (attempt == null) {
            response.sendRedirect(request.getContextPath() + "/teacher/attempts?error=Attempt+not+found");
            return;
        }

        Exam exam = examDAO.findById(attempt.getExamId());
        if (exam == null || exam.getTeacherId() != teacher.getId()) {
            response.sendRedirect(request.getContextPath() + "/teacher/attempts?error=Unauthorized+access");
            return;
        }

        Result result = resultDAO.findByAttemptId(attemptId);
        List<StudentAnswer> answers = attemptDAO.getAnswerReviewList(attemptId);

        request.setAttribute("attempt", attempt);
        request.setAttribute("exam", exam);
        request.setAttribute("result", result);
        request.setAttribute("answers", answers);

        request.getRequestDispatcher("/teacher/student-review.jsp").forward(request, response);
    }
}

