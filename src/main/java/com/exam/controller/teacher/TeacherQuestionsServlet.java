package com.exam.controller.teacher;

import com.exam.dao.ExamDAO;
import com.exam.dao.QuestionDAO;
import com.exam.model.Exam;
import com.exam.model.Question;
import com.exam.model.Teacher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "TeacherQuestionsServlet", urlPatterns = {"/teacher/questions"})
public class TeacherQuestionsServlet extends HttpServlet {

    private final QuestionDAO questionDAO = new QuestionDAO();
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
        if (examIdParam == null || examIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/teacher/exams");
            return;
        }

        int examId = Integer.parseInt(examIdParam.trim());
        Exam exam = examDAO.findById(examId);
        if (exam == null || exam.getTeacherId() != teacher.getId()) {
            response.sendRedirect(request.getContextPath() + "/teacher/exams?error=Unauthorized+access+to+exam");
            return;
        }

        List<Question> questions = questionDAO.findByExamId(examId);
        request.setAttribute("exam", exam);
        request.setAttribute("questions", questions);
        request.getRequestDispatcher("/teacher/questions.jsp").forward(request, response);
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

        int examId = Integer.parseInt(request.getParameter("examId"));
        Exam exam = examDAO.findById(examId);
        if (exam == null || exam.getTeacherId() != teacher.getId()) {
            response.sendRedirect(request.getContextPath() + "/teacher/exams?error=Unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            boolean deleted = questionDAO.delete(questionId);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/teacher/questions?examId=" + examId + "&msg=Question+deleted+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/questions?examId=" + examId + "&error=Failed+to+delete+question");
            }
            return;
        }

        String questionText = request.getParameter("questionText");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctOption = request.getParameter("correctOption");
        String marksStr = request.getParameter("marks");
        String explanation = request.getParameter("explanation");
        String questionIdStr = request.getParameter("questionId");

        if (questionText == null || optionA == null || optionB == null || optionC == null || optionD == null || correctOption == null ||
            questionText.trim().isEmpty() || optionA.trim().isEmpty() || optionB.trim().isEmpty() || optionC.trim().isEmpty() || optionD.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/teacher/questions?examId=" + examId + "&error=Question+text+and+all+4+options+are+mandatory");
            return;
        }

        int marks = 1;
        try {
            if (marksStr != null && !marksStr.trim().isEmpty()) {
                marks = Integer.parseInt(marksStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        Question q = new Question();
        q.setExamId(examId);
        q.setQuestionText(questionText.trim());
        q.setOptionA(optionA.trim());
        q.setOptionB(optionB.trim());
        q.setOptionC(optionC.trim());
        q.setOptionD(optionD.trim());
        q.setCorrectOption(correctOption.trim().toUpperCase());
        q.setMarks(marks);
        q.setExplanation(explanation != null ? explanation.trim() : "");

        if (questionIdStr != null && !questionIdStr.trim().isEmpty()) {
            q.setId(Integer.parseInt(questionIdStr.trim()));
            boolean updated = questionDAO.update(q);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/teacher/questions?examId=" + examId + "&msg=Question+updated+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/questions?examId=" + examId + "&error=Failed+to+update+question");
            }
        } else {
            boolean created = questionDAO.create(q);
            if (created) {
                response.sendRedirect(request.getContextPath() + "/teacher/questions?examId=" + examId + "&msg=Question+added+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/teacher/questions?examId=" + examId + "&error=Failed+to+add+question");
            }
        }
    }
}

