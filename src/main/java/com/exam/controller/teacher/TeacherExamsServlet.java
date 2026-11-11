package com.exam.controller.teacher;

import com.exam.dao.ExamDAO;
import com.exam.dao.SubjectDAO;
import com.exam.model.Exam;
import com.exam.model.Subject;
import com.exam.model.Teacher;
import com.exam.util.DateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "TeacherExamsServlet", urlPatterns = {"/teacher/exams"})
public class TeacherExamsServlet extends HttpServlet {

    private final ExamDAO examDAO = new ExamDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Teacher teacher = (Teacher) session.getAttribute("currentTeacher");
        if (teacher == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("new".equalsIgnoreCase(action)) {
            List<Subject> subjects = subjectDAO.findAll();
            request.setAttribute("subjects", subjects);
            request.getRequestDispatcher("/teacher/exam-form.jsp").forward(request, response);
            return;
        } else if ("edit".equalsIgnoreCase(action)) {
            int examId = Integer.parseInt(request.getParameter("id"));
            Exam exam = examDAO.findById(examId);
            if (exam == null || exam.getTeacherId() != teacher.getId()) {
                response.sendRedirect(request.getContextPath() + "/teacher/exams?error=Unauthorized+or+exam+not+found");
                return;
            }
            List<Subject> subjects = subjectDAO.findAll();
            request.setAttribute("exam", exam);
            request.setAttribute("subjects", subjects);
            request.getRequestDispatcher("/teacher/exam-form.jsp").forward(request, response);
            return;
        }

        List<Exam> exams = examDAO.findByTeacherId(teacher.getId());
        request.setAttribute("exams", exams);
        request.getRequestDispatcher("/teacher/exams.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Teacher teacher = (Teacher) session.getAttribute("currentTeacher");
        if (teacher == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            int examId = Integer.parseInt(request.getParameter("examId"));
            boolean deleted = examDAO.delete(examId, teacher.getId());
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/teacher/exams?msg=Exam+deleted+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/exams?error=Failed+to+delete+exam");
            }
            return;
        }

        // Create or Update
        String examIdStr = request.getParameter("examId");
        String subjectIdStr = request.getParameter("subjectId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String instructions = request.getParameter("instructions");
        String durationStr = request.getParameter("durationMinutes");
        String totalMarksStr = request.getParameter("totalMarks");
        String passingMarksStr = request.getParameter("passingMarks");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        String allowMultipleAttemptsStr = request.getParameter("allowMultipleAttempts");
        String negativeMarkingStr = request.getParameter("negativeMarkingPerQuestion");
        String randomizeStr = request.getParameter("randomizeQuestions");
        String publishedStr = request.getParameter("published");

        if (title == null || title.trim().isEmpty() || subjectIdStr == null || startTimeStr == null || endTimeStr == null) {
            response.sendRedirect(request.getContextPath() + "/teacher/exams?error=Please+complete+all+mandatory+fields");
            return;
        }

        int subjectId = Integer.parseInt(subjectIdStr.trim());
        int durationMinutes = Integer.parseInt(durationStr != null ? durationStr.trim() : "30");
        int totalMarks = Integer.parseInt(totalMarksStr != null ? totalMarksStr.trim() : "100");
        int passingMarks = Integer.parseInt(passingMarksStr != null ? passingMarksStr.trim() : "40");
        Timestamp startTime = DateUtil.parseInputTimestamp(startTimeStr);
        Timestamp endTime = DateUtil.parseInputTimestamp(endTimeStr);
        boolean allowMultiple = "true".equalsIgnoreCase(allowMultipleAttemptsStr) || "1".equals(allowMultipleAttemptsStr) || "on".equalsIgnoreCase(allowMultipleAttemptsStr);
        double negativeMarking = 0.0;
        try {
            if (negativeMarkingStr != null && !negativeMarkingStr.trim().isEmpty()) {
                negativeMarking = Double.parseDouble(negativeMarkingStr.trim());
            }
        } catch (NumberFormatException ignored) {}
        boolean randomize = "true".equalsIgnoreCase(randomizeStr) || "1".equals(randomizeStr) || "on".equalsIgnoreCase(randomizeStr);
        boolean published = "true".equalsIgnoreCase(publishedStr) || "1".equals(publishedStr) || "on".equalsIgnoreCase(publishedStr);

        Exam exam = new Exam();
        exam.setTeacherId(teacher.getId());
        exam.setSubjectId(subjectId);
        exam.setTitle(title.trim());
        exam.setDescription(description != null ? description.trim() : "");
        exam.setInstructions(instructions != null ? instructions.trim() : "");
        exam.setDurationMinutes(durationMinutes);
        exam.setTotalMarks(totalMarks);
        exam.setPassingMarks(passingMarks);
        exam.setStartTime(startTime);
        exam.setEndTime(endTime);
        exam.setAllowMultipleAttempts(allowMultiple);
        exam.setNegativeMarkingPerQuestion(negativeMarking);
        exam.setRandomizeQuestions(randomize);
        exam.setPublished(published);

        if (examIdStr != null && !examIdStr.trim().isEmpty()) {
            // Update
            int examId = Integer.parseInt(examIdStr.trim());
            exam.setId(examId);
            boolean updated = examDAO.update(exam);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/teacher/exams?msg=Exam+updated+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/exams?error=Failed+to+update+exam");
            }
        } else {
            // Create
            int newId = examDAO.create(exam);
            if (newId > 0) {
                response.sendRedirect(request.getContextPath() + "/teacher/questions?examId=" + newId + "&msg=Exam+created!+Now+add+questions+below.");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/exams?error=Failed+to+create+exam");
            }
        }
    }
}

