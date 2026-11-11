package com.exam.controller.teacher;

import com.exam.dao.DashboardDAO;
import com.exam.dao.ExamDAO;
import com.exam.model.DashboardStats;
import com.exam.model.Exam;
import com.exam.model.Teacher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "TeacherDashboardServlet", urlPatterns = {"/teacher/dashboard"})
public class TeacherDashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
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

        DashboardStats stats = dashboardDAO.getTeacherStats(teacher.getId());
        List<Exam> exams = examDAO.findByTeacherId(teacher.getId());

        request.setAttribute("stats", stats);
        request.setAttribute("exams", exams);
        request.getRequestDispatcher("/teacher/dashboard.jsp").forward(request, response);
    }
}

