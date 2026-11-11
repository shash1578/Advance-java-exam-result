package com.exam.controller.teacher;

import com.exam.dao.ExamDAO;
import com.exam.dao.ResultDAO;
import com.exam.model.Exam;
import com.exam.model.Result;
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
import java.util.Map;

@WebServlet(name = "TeacherResultsServlet", urlPatterns = {"/teacher/results"})
public class TeacherResultsServlet extends HttpServlet {

    private final ResultDAO resultDAO = new ResultDAO();
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

        List<Exam> teacherExams = examDAO.findByTeacherId(teacher.getId());
        String examIdParam = request.getParameter("examId");

        List<Result> results = new ArrayList<>();
        Map<String, Object> examStats = null;
        Exam currentExam = null;

        if (examIdParam != null && !examIdParam.trim().isEmpty()) {
            int examId = Integer.parseInt(examIdParam.trim());
            Exam exam = examDAO.findById(examId);
            if (exam != null && exam.getTeacherId() == teacher.getId()) {
                currentExam = exam;
                results = resultDAO.findByExamId(examId);
                examStats = resultDAO.getExamStatistics(examId);
                request.setAttribute("selectedExamId", examId);
            }
        } else if (!teacherExams.isEmpty()) {
            currentExam = teacherExams.get(0);
            results = resultDAO.findByExamId(currentExam.getId());
            examStats = resultDAO.getExamStatistics(currentExam.getId());
            request.setAttribute("selectedExamId", currentExam.getId());
        }

        request.setAttribute("teacherExams", teacherExams);
        request.setAttribute("results", results);
        request.setAttribute("examStats", examStats);
        request.setAttribute("currentExam", currentExam);

        request.getRequestDispatcher("/teacher/results.jsp").forward(request, response);
    }
}

