package com.exam.dao;

import com.exam.model.ExamAttempt;
import com.exam.model.StudentAnswer;
import com.exam.util.DBConnection;
import com.exam.util.DateUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ExamAttemptDAO {

    private static final Logger LOGGER = Logger.getLogger(ExamAttemptDAO.class.getName());

    public int createAttempt(int examId, int studentId) {
        String sql = "INSERT INTO exam_attempts (exam_id, student_id, start_time, status, total_score) VALUES (?, ?, NOW(), 'IN_PROGRESS', 0.00)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, examId);
            stmt.setInt(2, studentId);
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating exam attempt for exam: " + examId + ", student: " + studentId, e);
        }
        return -1;
    }

    public ExamAttempt findById(int id) {
        String sql = "SELECT a.*, e.title AS exam_title, e.duration_minutes, e.total_marks, e.passing_marks, " +
                     "s.subject_name, u.full_name AS student_name, st.roll_number, st.department " +
                     "FROM exam_attempts a " +
                     "JOIN exams e ON a.exam_id = e.id " +
                     "JOIN subjects s ON e.subject_id = s.id " +
                     "JOIN students st ON a.student_id = st.id " +
                     "JOIN users u ON st.user_id = u.id " +
                     "WHERE a.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapAttempt(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding attempt by id: " + id, e);
        }
        return null;
    }

    public ExamAttempt findActiveAttempt(int examId, int studentId) {
        String sql = "SELECT a.*, e.title AS exam_title, e.duration_minutes, e.total_marks, e.passing_marks, " +
                     "s.subject_name, u.full_name AS student_name, st.roll_number, st.department " +
                     "FROM exam_attempts a " +
                     "JOIN exams e ON a.exam_id = e.id " +
                     "JOIN subjects s ON e.subject_id = s.id " +
                     "JOIN students st ON a.student_id = st.id " +
                     "JOIN users u ON st.user_id = u.id " +
                     "WHERE a.exam_id = ? AND a.student_id = ? AND a.status = 'IN_PROGRESS' " +
                     "ORDER BY a.id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, examId);
            stmt.setInt(2, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapAttempt(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding active attempt", e);
        }
        return null;
    }

    public int getAttemptCount(int examId, int studentId) {
        String sql = "SELECT COUNT(*) FROM exam_attempts WHERE exam_id = ? AND student_id = ? AND status = 'SUBMITTED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, examId);
            stmt.setInt(2, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting attempts", e);
        }
        return 0;
    }

    public boolean hasStudentCompletedExam(int examId, int studentId) {
        String sql = "SELECT COUNT(*) FROM exam_attempts WHERE exam_id = ? AND student_id = ? AND status = 'SUBMITTED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, examId);
            stmt.setInt(2, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking completion status", e);
        }
        return false;
    }

    public List<ExamAttempt> findByExamId(int examId) {
        List<ExamAttempt> list = new ArrayList<>();
        String sql = "SELECT a.*, e.title AS exam_title, e.duration_minutes, e.total_marks, e.passing_marks, " +
                     "s.subject_name, u.full_name AS student_name, st.roll_number, st.department " +
                     "FROM exam_attempts a " +
                     "JOIN exams e ON a.exam_id = e.id " +
                     "JOIN subjects s ON e.subject_id = s.id " +
                     "JOIN students st ON a.student_id = st.id " +
                     "JOIN users u ON st.user_id = u.id " +
                     "WHERE a.exam_id = ? " +
                     "ORDER BY a.start_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, examId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAttempt(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding attempts by exam id: " + examId, e);
        }
        return list;
    }

    public List<ExamAttempt> findByStudentId(int studentId) {
        List<ExamAttempt> list = new ArrayList<>();
        String sql = "SELECT a.*, e.title AS exam_title, e.duration_minutes, e.total_marks, e.passing_marks, " +
                     "s.subject_name, u.full_name AS student_name, st.roll_number, st.department " +
                     "FROM exam_attempts a " +
                     "JOIN exams e ON a.exam_id = e.id " +
                     "JOIN subjects s ON e.subject_id = s.id " +
                     "JOIN students st ON a.student_id = st.id " +
                     "JOIN users u ON st.user_id = u.id " +
                     "WHERE a.student_id = ? " +
                     "ORDER BY a.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAttempt(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding attempts by student id: " + studentId, e);
        }
        return list;
    }

    /**
     * Saves or updates a student answer in database for real-time progress saving.
     */
    public boolean saveAnswer(int attemptId, int questionId, String selectedOption, boolean isMarkedForReview) {
        String sql = "INSERT INTO student_answers (attempt_id, question_id, selected_option, is_marked_for_review) " +
                     "VALUES (?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE selected_option = VALUES(selected_option), is_marked_for_review = VALUES(is_marked_for_review), saved_at = NOW()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, attemptId);
            stmt.setInt(2, questionId);
            if (selectedOption != null && !selectedOption.trim().isEmpty()) {
                stmt.setString(3, selectedOption.trim().toUpperCase());
            } else {
                stmt.setNull(3, Types.VARCHAR);
            }
            stmt.setBoolean(4, isMarkedForReview);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving student answer for attempt: " + attemptId, e);
            return false;
        }
    }

    /**
     * Marks a question for review without altering the selected option.
     */
    public boolean toggleMarkForReview(int attemptId, int questionId, boolean isMarkedForReview) {
        String sql = "INSERT INTO student_answers (attempt_id, question_id, selected_option, is_marked_for_review) " +
                     "VALUES (?, ?, NULL, ?) " +
                     "ON DUPLICATE KEY UPDATE is_marked_for_review = VALUES(is_marked_for_review), saved_at = NOW()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, attemptId);
            stmt.setInt(2, questionId);
            stmt.setBoolean(3, isMarkedForReview);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error toggling review flag", e);
            return false;
        }
    }

    /**
     * Gets all answers saved by student for an attempt.
     */
    public List<StudentAnswer> getSavedAnswers(int attemptId) {
        List<StudentAnswer> list = new ArrayList<>();
        String sql = "SELECT * FROM student_answers WHERE attempt_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, attemptId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    StudentAnswer a = new StudentAnswer();
                    a.setId(rs.getInt("id"));
                    a.setAttemptId(rs.getInt("attempt_id"));
                    a.setQuestionId(rs.getInt("question_id"));
                    a.setSelectedOption(rs.getString("selected_option"));
                    a.setMarkedForReview(rs.getBoolean("is_marked_for_review"));
                    a.setCorrect((Boolean) rs.getObject("is_correct"));
                    a.setMarksAwarded(rs.getDouble("marks_awarded"));
                    a.setSavedAt(rs.getTimestamp("saved_at"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting saved answers for attempt: " + attemptId, e);
        }
        return list;
    }

    /**
     * Retrieves full question and answer review data (with correct options and explanations) for post-submission breakdown.
     */
    public List<StudentAnswer> getAnswerReviewList(int attemptId) {
        List<StudentAnswer> list = new ArrayList<>();
        String sql = "SELECT q.id AS question_id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, " +
                     "q.correct_option, q.marks AS question_marks, q.explanation, " +
                     "sa.id AS answer_id, sa.selected_option, sa.is_marked_for_review, sa.is_correct, sa.marks_awarded " +
                     "FROM questions q " +
                     "JOIN exam_attempts a ON a.exam_id = q.exam_id " +
                     "LEFT JOIN student_answers sa ON sa.attempt_id = a.id AND sa.question_id = q.id " +
                     "WHERE a.id = ? ORDER BY q.id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, attemptId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    StudentAnswer sa = new StudentAnswer();
                    sa.setId(rs.getInt("answer_id"));
                    sa.setAttemptId(attemptId);
                    sa.setQuestionId(rs.getInt("question_id"));
                    sa.setQuestionText(rs.getString("question_text"));
                    sa.setOptionA(rs.getString("option_a"));
                    sa.setOptionB(rs.getString("option_b"));
                    sa.setOptionC(rs.getString("option_c"));
                    sa.setOptionD(rs.getString("option_d"));
                    sa.setCorrectOption(rs.getString("correct_option"));
                    sa.setQuestionMarks(rs.getInt("question_marks"));
                    sa.setExplanation(rs.getString("explanation"));

                    sa.setSelectedOption(rs.getString("selected_option"));
                    sa.setMarkedForReview(rs.getBoolean("is_marked_for_review"));
                    sa.setCorrect((Boolean) rs.getObject("is_correct"));
                    sa.setMarksAwarded(rs.getDouble("marks_awarded"));
                    list.add(sa);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading review list for attempt: " + attemptId, e);
        }
        return list;
    }

    /**
     * Updates an evaluated student answer with correctness and marks awarded.
     */
    public boolean updateAnswerEvaluation(int attemptId, int questionId, boolean isCorrect, double marksAwarded) {
        String sql = "UPDATE student_answers SET is_correct = ?, marks_awarded = ? WHERE attempt_id = ? AND question_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, isCorrect);
            stmt.setDouble(2, marksAwarded);
            stmt.setInt(3, attemptId);
            stmt.setInt(4, questionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating answer evaluation", e);
            return false;
        }
    }

    /**
     * Finalizes the attempt: marks it SUBMITTED or EXPIRED, sets end_time and total_score.
     */
    public boolean finalizeAttempt(int attemptId, double totalScore, ExamAttempt.AttemptStatus status) {
        String sql = "UPDATE exam_attempts SET end_time = NOW(), status = ?, total_score = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setDouble(2, totalScore);
            stmt.setInt(3, attemptId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finalizing attempt: " + attemptId, e);
            return false;
        }
    }

    public int countTotalAttempts() {
        String sql = "SELECT COUNT(*) FROM exam_attempts WHERE status = 'SUBMITTED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting total attempts", e);
        }
        return 0;
    }

    public int countAttemptsByTeacher(int teacherId) {
        String sql = "SELECT COUNT(*) FROM exam_attempts a JOIN exams e ON a.exam_id = e.id WHERE e.teacher_id = ? AND a.status = 'SUBMITTED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, teacherId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting attempts by teacher: " + teacherId, e);
        }
        return 0;
    }

    private ExamAttempt mapAttempt(ResultSet rs) throws SQLException {
        ExamAttempt a = new ExamAttempt();
        a.setId(rs.getInt("id"));
        a.setExamId(rs.getInt("exam_id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setStartTime(rs.getTimestamp("start_time"));
        a.setEndTime(rs.getTimestamp("end_time"));
        a.setStatus(ExamAttempt.AttemptStatus.valueOf(rs.getString("status")));
        a.setTotalScore(rs.getDouble("total_score"));
        a.setCreatedAt(rs.getTimestamp("created_at"));

        a.setExamTitle(rs.getString("exam_title"));
        a.setDurationMinutes(rs.getInt("duration_minutes"));
        a.setTotalMarks(rs.getInt("total_marks"));
        a.setPassingMarks(rs.getInt("passing_marks"));
        a.setSubjectName(rs.getString("subject_name"));
        a.setStudentName(rs.getString("student_name"));
        a.setStudentRollNumber(rs.getString("roll_number"));
        a.setStudentDepartment(rs.getString("department"));
        return a;
    }
}

