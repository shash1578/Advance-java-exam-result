package com.exam.controller.teacher;

import com.exam.dao.ExamAttemptDAO;
import com.exam.dao.ExamDAO;
import com.exam.model.Exam;
import com.exam.model.ExamAttempt;
import com.exam.model.Teacher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "TeacherAttemptsServlet", urlPatterns = {"/teacher/attempts"})
public class TeacherAttemptsServlet extends HttpServlet {

    private final ExamAttemptDAO attemptDAO = new ExamAttemptDAO();
    private final ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Teacher teacher = (Teacher) session.getAttribute("currentTeacher");
        if (teacher == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String examIdParam = request.getParameter("examId");
        List<Exam> teacherExams = examDAO.findByTeacherId(teacher.getId());
        List<ExamAttempt> attempts = new ArrayList<>();

        if (examIdParam != null && !examIdParam.trim().isEmpty()) {
            int examId = Integer.parseInt(examIdParam.trim());
            Exam exam = examDAO.findById(examId);
            if (exam != null && exam.getTeacherId() == teacher.getId()) {
                attempts = attemptDAO.findByExamId(examId);
                request.setAttribute("selectedExamId", examId);
            }
        } else {
            // Aggregate attempts across all teacher exams
            for (Exam e : teacherExams) {
                attempts.addAll(attemptDAO.findByExamId(e.getId()));
            }
        }

        request.setAttribute("teacherExams", teacherExams);
        request.setAttribute("attempts", attempts);
        request.getRequestDispatcher("/teacher/attempts.jsp").forward(request, response);
    }
}

