package com.exam.controller.admin;

import com.exam.dao.DashboardDAO;
import com.exam.dao.ExamDAO;
import com.exam.dao.ResultDAO;
import com.exam.model.DashboardStats;
import com.exam.model.Exam;
import com.exam.model.Result;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final ExamDAO examDAO = new ExamDAO();
    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardStats stats = dashboardDAO.getAdminStats();
        List<Exam> recentExams = examDAO.findAll();
        List<Result> recentResults = resultDAO.findAll();

        if (recentExams.size() > 5) {
            recentExams = recentExams.subList(0, 5);
        }
        if (recentResults.size() > 5) {
            recentResults = recentResults.subList(0, 5);
        }

        request.setAttribute("stats", stats);
        request.setAttribute("recentExams", recentExams);
        request.setAttribute("recentResults", recentResults);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}

