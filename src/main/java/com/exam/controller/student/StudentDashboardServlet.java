package com.exam.controller.student;

import com.exam.dao.DashboardDAO;
import com.exam.dao.ExamDAO;
import com.exam.dao.ResultDAO;
import com.exam.model.DashboardStats;
import com.exam.model.Exam;
import com.exam.model.Result;
import com.exam.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final ExamDAO examDAO = new ExamDAO();
    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("currentStudent");
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DashboardStats stats = dashboardDAO.getStudentStats(student.getId());
        List<Exam> availableExams = examDAO.findAvailableForStudent(student.getId());
        List<Result> recentResults = resultDAO.findByStudentId(student.getId());

        if (recentResults.size() > 5) {
            recentResults = recentResults.subList(0, 5);
        }

        request.setAttribute("stats", stats);
        request.setAttribute("availableExams", availableExams);
        request.setAttribute("recentResults", recentResults);

        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }
}

