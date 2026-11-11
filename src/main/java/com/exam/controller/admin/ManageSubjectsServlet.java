package com.exam.controller.admin;

import com.exam.dao.SubjectDAO;
import com.exam.model.Subject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageSubjectsServlet", urlPatterns = {"/admin/subjects"})
public class ManageSubjectsServlet extends HttpServlet {

    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Subject> subjects = subjectDAO.findAll();
        request.setAttribute("subjects", subjects);
        request.getRequestDispatcher("/admin/subjects.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "add";

        switch (action) {
            case "add":
                handleAddSubject(request, response);
                break;
            case "edit":
                handleEditSubject(request, response);
                break;
            case "delete":
                handleDeleteSubject(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/subjects");
                break;
        }
    }

    private void handleAddSubject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String code = request.getParameter("subjectCode");
        String name = request.getParameter("subjectName");
        String description = request.getParameter("description");

        if (code == null || name == null || code.trim().isEmpty() || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?error=Subject+code+and+name+are+required");
            return;
        }

        code = code.trim().toUpperCase();
        if (subjectDAO.existsByCode(code, 0)) {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?error=Subject+code+already+exists");
            return;
        }

        Subject s = new Subject();
        s.setSubjectCode(code);
        s.setSubjectName(name.trim());
        s.setDescription(description != null ? description.trim() : "");

        boolean created = subjectDAO.create(s);
        if (created) {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?msg=Subject+added+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?error=Failed+to+add+subject");
        }
    }

    private void handleEditSubject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("subjectId"));
        String code = request.getParameter("subjectCode");
        String name = request.getParameter("subjectName");
        String description = request.getParameter("description");

        code = code.trim().toUpperCase();
        if (subjectDAO.existsByCode(code, id)) {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?error=Subject+code+already+exists");
            return;
        }

        Subject s = subjectDAO.findById(id);
        if (s != null) {
            s.setSubjectCode(code);
            s.setSubjectName(name.trim());
            s.setDescription(description != null ? description.trim() : "");
            boolean updated = subjectDAO.update(s);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/subjects?msg=Subject+updated+successfully");
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/subjects?error=Failed+to+update+subject");
    }

    private void handleDeleteSubject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("subjectId"));
        boolean deleted = subjectDAO.delete(id);
        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?msg=Subject+deleted+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/subjects?error=Failed+to+delete+subject");
        }
    }
}

