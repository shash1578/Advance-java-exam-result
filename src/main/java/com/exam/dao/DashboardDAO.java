package com.exam.dao;

import com.exam.model.DashboardStats;
import com.exam.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DashboardDAO {

    private static final Logger LOGGER = Logger.getLogger(DashboardDAO.class.getName());

    private final StudentDAO studentDAO = new StudentDAO();
    private final TeacherDAO teacherDAO = new TeacherDAO();
    private final ExamDAO examDAO = new ExamDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final ExamAttemptDAO attemptDAO = new ExamAttemptDAO();
    private final ResultDAO resultDAO = new ResultDAO();

    public DashboardStats getAdminStats() {
        DashboardStats stats = new DashboardStats();
        stats.setTotalStudents(studentDAO.countAll());
        stats.setTotalTeachers(teacherDAO.countAll());
        stats.setTotalExams(examDAO.countAll());
        stats.setTotalSubjects(subjectDAO.countAll());
        stats.setTotalAttempts(attemptDAO.countTotalAttempts());
        stats.setOverallPassRate(resultDAO.getOverallPassRate());
        return stats;
    }

    public DashboardStats getTeacherStats(int teacherId) {
        DashboardStats stats = new DashboardStats();
        stats.setTeacherExamsCount(examDAO.countByTeacherId(teacherId));
        QuestionDAO questionDAO = new QuestionDAO();
        stats.setTeacherQuestionsCount(questionDAO.countByTeacherId(teacherId));
        stats.setTeacherAttemptsCount(attemptDAO.countAttemptsByTeacher(teacherId));
        stats.setTeacherAverageScore(resultDAO.getTeacherAverageScore(teacherId));
        return stats;
    }

    public DashboardStats getStudentStats(int studentId) {
        DashboardStats stats = new DashboardStats();
        stats.setAvailableExamsCount(examDAO.findAvailableForStudent(studentId).size());
        stats.setUpcomingExamsCount(examDAO.findUpcomingForStudent().size());
        stats.setCompletedExamsCount(examDAO.findCompletedForStudent(studentId).size());

        String sql = "SELECT AVG(percentage) FROM results WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.setStudentAveragePercentage(rs.getDouble(1));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting student dashboard stats: " + studentId, e);
        }
        return stats;
    }
}

