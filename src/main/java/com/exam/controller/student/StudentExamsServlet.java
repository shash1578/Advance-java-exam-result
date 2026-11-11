package com.exam.controller.student;

import com.exam.dao.ExamDAO;
import com.exam.model.Exam;
import com.exam.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentExamsServlet", urlPatterns = {"/student/exams"})
public class StudentExamsServlet extends HttpServlet {

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

        List<Exam> availableExams = examDAO.findAvailableForStudent(student.getId());
        List<Exam> upcomingExams = examDAO.findUpcomingForStudent();
        List<Exam> completedExams = examDAO.findCompletedForStudent(student.getId());

        request.setAttribute("availableExams", availableExams);
        request.setAttribute("upcomingExams", upcomingExams);
        request.setAttribute("completedExams", completedExams);

        request.getRequestDispatcher("/student/exams.jsp").forward(request, response);
    }
}

