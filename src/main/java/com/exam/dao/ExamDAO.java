package com.exam.dao;

import com.exam.model.Exam;
import com.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ExamDAO {

    private static final Logger LOGGER = Logger.getLogger(ExamDAO.class.getName());

    public int create(Exam exam) {
        String sql = "INSERT INTO exams (teacher_id, subject_id, title, description, instructions, " +
                     "duration_minutes, total_marks, passing_marks, start_time, end_time, " +
                     "allow_multiple_attempts, negative_marking_per_question, randomize_questions, is_published) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, exam.getTeacherId());
            stmt.setInt(2, exam.getSubjectId());
            stmt.setString(3, exam.getTitle());
            stmt.setString(4, exam.getDescription());
            stmt.setString(5, exam.getInstructions());
            stmt.setInt(6, exam.getDurationMinutes());
            stmt.setInt(7, exam.getTotalMarks());
            stmt.setInt(8, exam.getPassingMarks());
            stmt.setTimestamp(9, exam.getStartTime());
            stmt.setTimestamp(10, exam.getEndTime());
            stmt.setBoolean(11, exam.isAllowMultipleAttempts());
            stmt.setDouble(12, exam.getNegativeMarkingPerQuestion());
            stmt.setBoolean(13, exam.isRandomizeQuestions());
            stmt.setBoolean(14, exam.isPublished());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        exam.setId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating exam", e);
        }
        return -1;
    }

    public boolean update(Exam exam) {
        String sql = "UPDATE exams SET subject_id = ?, title = ?, description = ?, instructions = ?, " +
                     "duration_minutes = ?, total_marks = ?, passing_marks = ?, start_time = ?, end_time = ?, " +
                     "allow_multiple_attempts = ?, negative_marking_per_question = ?, randomize_questions = ?, is_published = ? " +
                     "WHERE id = ? AND teacher_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, exam.getSubjectId());
            stmt.setString(2, exam.getTitle());
            stmt.setString(3, exam.getDescription());
            stmt.setString(4, exam.getInstructions());
            stmt.setInt(5, exam.getDurationMinutes());
            stmt.setInt(6, exam.getTotalMarks());
            stmt.setInt(7, exam.getPassingMarks());
            stmt.setTimestamp(8, exam.getStartTime());
            stmt.setTimestamp(9, exam.getEndTime());
            stmt.setBoolean(10, exam.isAllowMultipleAttempts());
            stmt.setDouble(11, exam.getNegativeMarkingPerQuestion());
            stmt.setBoolean(12, exam.isRandomizeQuestions());
            stmt.setBoolean(13, exam.isPublished());
            stmt.setInt(14, exam.getId());
            stmt.setInt(15, exam.getTeacherId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating exam: " + exam.getId(), e);
            return false;
        }
    }

    public boolean delete(int examId, int teacherId) {
        String sql = teacherId > 0 ? "DELETE FROM exams WHERE id = ? AND teacher_id = ?" : "DELETE FROM exams WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, examId);
            if (teacherId > 0) {
                stmt.setInt(2, teacherId);
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting exam: " + examId, e);
            return false;
        }
    }

    public Exam findById(int id) {
        String sql = "SELECT e.*, s.subject_name, s.subject_code, u.full_name AS teacher_name, " +
                     "(SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.id) AS question_count, " +
                     "(SELECT COUNT(*) FROM exam_attempts a WHERE a.exam_id = e.id) AS attempt_count " +
                     "FROM exams e " +
                     "JOIN subjects s ON e.subject_id = s.id " +
                     "JOIN teachers t ON e.teacher_id = t.id " +
                     "JOIN users u ON t.user_id = u.id " +
                     "WHERE e.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapExam(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding exam by id: " + id, e);
        }
        return null;
    }

    public List<Exam> findAll() {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT e.*, s.subject_name, s.subject_code, u.full_name AS teacher_name, " +
                     "(SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.id) AS question_count, " +
                     "(SELECT COUNT(*) FROM exam_attempts a WHERE a.exam_id = e.id) AS attempt_count " +
                     "FROM exams e " +
                     "JOIN subjects s ON e.subject_id = s.id " +
                     "JOIN teachers t ON e.teacher_id = t.id " +
                     "JOIN users u ON t.user_id = u.id " +
                     "ORDER BY e.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapExam(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all exams", e);
        }
        return list;
    }

    public List<Exam> findByTeacherId(int teacherId) {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT e.*, s.subject_name, s.subject_code, u.full_name AS teacher_name, " +
                     "(SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.id) AS question_count, " +
                     "(SELECT COUNT(*) FROM exam_attempts a WHERE a.exam_id = e.id) AS attempt_count " +
                     "FROM exams e " +
                     "JOIN subjects s ON e.subject_id = s.id " +
                     "JOIN teachers t ON e.teacher_id = t.id " +
                     "JOIN users u ON t.user_id = u.id " +
                     "WHERE e.teacher_id = ? " +
                     "ORDER BY e.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, teacherId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapExam(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding exams by teacherId: " + teacherId, e);
        }
        return list;
    }

    public List<Exam> findAvailableForStudent(int studentId) {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT e.*, s.subject_name, s.subject_code, u.full_name AS teacher_name, " +
                     "(SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.id) AS question_count, " +
                     "(SELECT COUNT(*) FROM exam_attempts a WHERE a.exam_id = e.id) AS attempt_count, " +
                     "att.id AS student_attempt_id, att.status AS student_attempt_status " +
                     "FROM exams e " +
                     "JOIN subjects s ON e.subject_id = s.id " +
                     "JOIN teachers t ON e.teacher_id = t.id " +
                     "JOIN users u ON t.user_id = u.id " +
                     "LEFT JOIN exam_attempts att ON att.exam_id = e.id AND att.student_id = ? " +
                     "WHERE e.is_published = TRUE AND NOW() BETWEEN e.start_time AND e.end_time " +
                     "ORDER BY e.end_time ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Exam exam = mapExam(rs);
                    int attId = rs.getInt("student_attempt_id");
                    if (attId > 0) {
                        exam.setStudentAttempted(true);
                        exam.setStudentAttemptId(attId);
                        exam.setStudentAttemptStatus(rs.getString("student_attempt_status"));
                    } else {
                        exam.setStudentAttempted(false);
                    }
                    list.add(exam);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding available exams for student: " + studentId, e);
        }
        return list;
    }

    public List<Exam> findUpcomingForStudent() {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT e.*, s.subject_name, s.subject_code, u.full_name AS teacher_name, " +
                     "(SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.id) AS question_count, " +
                     "0 AS attempt_count " +
                     "FROM exams e " +
                     "JOIN subjects s ON e.subject_id = s.id " +
                     "JOIN teachers t ON e.teacher_id = t.id " +
                     "JOIN users u ON t.user_id = u.id " +
                     "WHERE e.is_published = TRUE AND NOW() < e.start_time " +
                     "ORDER BY e.start_time ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapExam(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding upcoming exams", e);
        }
        return list;
    }

    public List<Exam> findCompletedForStudent(int studentId) {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT e.*, s.subject_name, s.subject_code, u.full_name AS teacher_name, " +
                     "(SELECT COUNT(*) FROM questions q WHERE q.exam_id = e.id) AS question_count, " +
                     "(SELECT COUNT(*) FROM exam_attempts a WHERE a.exam_id = e.id) AS attempt_count, " +
                     "att.id AS student_attempt_id, att.status AS student_attempt_status " +
                     "FROM exams e " +
                     "JOIN subjects s ON e.subject_id = s.id " +
                     "JOIN teachers t ON e.teacher_id = t.id " +
                     "JOIN users u ON t.user_id = u.id " +
                     "JOIN exam_attempts att ON att.exam_id = e.id AND att.student_id = ? " +
                     "WHERE att.status = 'SUBMITTED' " +
                     "ORDER BY att.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Exam exam = mapExam(rs);
                    exam.setStudentAttempted(true);
                    exam.setStudentAttemptId(rs.getInt("student_attempt_id"));
                    exam.setStudentAttemptStatus(rs.getString("student_attempt_status"));
                    list.add(exam);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding completed exams for student: " + studentId, e);
        }
        return list;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM exams";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting exams", e);
        }
        return 0;
    }

    public int countByTeacherId(int teacherId) {
        String sql = "SELECT COUNT(*) FROM exams WHERE teacher_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, teacherId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting teacher exams: " + teacherId, e);
        }
        return 0;
    }

    private Exam mapExam(ResultSet rs) throws SQLException {
        Exam e = new Exam();
        e.setId(rs.getInt("id"));
        e.setTeacherId(rs.getInt("teacher_id"));
        e.setSubjectId(rs.getInt("subject_id"));
        e.setTitle(rs.getString("title"));
        e.setDescription(rs.getString("description"));
        e.setInstructions(rs.getString("instructions"));
        e.setDurationMinutes(rs.getInt("duration_minutes"));
        e.setTotalMarks(rs.getInt("total_marks"));
        e.setPassingMarks(rs.getInt("passing_marks"));
        e.setStartTime(rs.getTimestamp("start_time"));
        e.setEndTime(rs.getTimestamp("end_time"));
        e.setAllowMultipleAttempts(rs.getBoolean("allow_multiple_attempts"));
        e.setNegativeMarkingPerQuestion(rs.getDouble("negative_marking_per_question"));
        e.setRandomizeQuestions(rs.getBoolean("randomize_questions"));
        e.setPublished(rs.getBoolean("is_published"));
        e.setCreatedAt(rs.getTimestamp("created_at"));

        e.setSubjectName(rs.getString("subject_name"));
        e.setSubjectCode(rs.getString("subject_code"));
        e.setTeacherName(rs.getString("teacher_name"));
        e.setQuestionCount(rs.getInt("question_count"));
        e.setAttemptCount(rs.getInt("attempt_count"));
        return e;
    }
}

