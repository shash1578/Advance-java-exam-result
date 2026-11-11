package com.exam.controller.admin;

import com.exam.dao.ExamDAO;
import com.exam.model.Exam;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminExamsServlet", urlPatterns = {"/admin/exams"})
public class AdminExamsServlet extends HttpServlet {

    private final ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Exam> exams = examDAO.findAll();
        request.setAttribute("exams", exams);
        request.getRequestDispatcher("/admin/exams.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            int examId = Integer.parseInt(request.getParameter("examId"));
            boolean deleted = examDAO.delete(examId, 0); // 0 allows admin override
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/exams?msg=Exam+deleted+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/exams?error=Failed+to+delete+exam");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/exams");
        }
    }
}

