package com.exam.dao;

import com.exam.model.Question;
import com.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class QuestionDAO {

    private static final Logger LOGGER = Logger.getLogger(QuestionDAO.class.getName());

    public boolean create(Question question) {
        String sql = "INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks, explanation) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, question.getExamId());
            stmt.setString(2, question.getQuestionText().trim());
            stmt.setString(3, question.getOptionA().trim());
            stmt.setString(4, question.getOptionB().trim());
            stmt.setString(5, question.getOptionC().trim());
            stmt.setString(6, question.getOptionD().trim());
            stmt.setString(7, question.getCorrectOption().trim().toUpperCase());
            stmt.setInt(8, question.getMarks());
            stmt.setString(9, question.getExplanation());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        question.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating question", e);
        }
        return false;
    }

    public boolean update(Question question) {
        String sql = "UPDATE questions SET question_text = ?, option_a = ?, option_b = ?, option_c = ?, option_d = ?, " +
                     "correct_option = ?, marks = ?, explanation = ? WHERE id = ? AND exam_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, question.getQuestionText().trim());
            stmt.setString(2, question.getOptionA().trim());
            stmt.setString(3, question.getOptionB().trim());
            stmt.setString(4, question.getOptionC().trim());
            stmt.setString(5, question.getOptionD().trim());
            stmt.setString(7, question.getCorrectOption().trim().toUpperCase());
            stmt.setInt(6, question.getMarks()); // note order swap fix below:
            // Let's set parameter indices properly
            stmt.setString(6, question.getCorrectOption().trim().toUpperCase());
            stmt.setInt(7, question.getMarks());
            stmt.setString(8, question.getExplanation());
            stmt.setInt(9, question.getId());
            stmt.setInt(10, question.getExamId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating question: " + question.getId(), e);
            return false;
        }
    }

    public boolean delete(int questionId) {
        String sql = "DELETE FROM questions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, questionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting question: " + questionId, e);
            return false;
        }
    }

    public Question findById(int id) {
        String sql = "SELECT * FROM questions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapQuestion(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding question by id: " + id, e);
        }
        return null;
    }

    /**
     * Retrieves full questions including correct answers (for teacher view, admin, and server-side grading).
     */
    public List<Question> findByExamId(int examId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE exam_id = ? ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, examId);
            try (ResultSet rs = stmt.executeQuery()) {
                int qNum = 1;
                while (rs.next()) {
                    Question q = mapQuestion(rs);
                    q.setQuestionNumber(qNum++);
                    list.add(q);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding questions for exam: " + examId, e);
        }
        return list;
    }

    /**
     * Retrieves sanitized questions for a student taking an examination.
     * Does NOT populate correctOption or explanation.
     * Joins student_answers so any previously saved responses are populated.
     */
    public List<Question> findSanitizedForStudent(int examId, int attemptId, boolean randomize) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT q.id, q.exam_id, q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, q.marks, " +
                     "sa.selected_option, sa.is_marked_for_review " +
                     "FROM questions q " +
                     "LEFT JOIN student_answers sa ON sa.question_id = q.id AND sa.attempt_id = ? " +
                     "WHERE q.exam_id = ? " +
                     "ORDER BY q.id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, attemptId);
            stmt.setInt(2, examId);
            try (ResultSet rs = stmt.executeQuery()) {
                int num = 1;
                while (rs.next()) {
                    Question q = new Question();
                    q.setId(rs.getInt("id"));
                    q.setExamId(rs.getInt("exam_id"));
                    q.setQuestionText(rs.getString("question_text"));
                    q.setOptionA(rs.getString("option_a"));
                    q.setOptionB(rs.getString("option_b"));
                    q.setOptionC(rs.getString("option_c"));
                    q.setOptionD(rs.getString("option_d"));
                    q.setMarks(rs.getInt("marks"));
                    q.setQuestionNumber(num++);

                    String selected = rs.getString("selected_option");
                    q.setStudentSelectedOption(selected);
                    q.setMarkedForReview(rs.getBoolean("is_marked_for_review"));
                    q.setAnswered(selected != null && !selected.trim().isEmpty());

                    // Intentionally NOT setting correctOption or explanation for security!
                    list.add(q);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading sanitized questions for attempt: " + attemptId, e);
        }

        if (randomize) {
            Collections.shuffle(list);
            for (int i = 0; i < list.size(); i++) {
                list.get(i).setQuestionNumber(i + 1);
            }
        }
        return list;
    }

    public int countByExamId(int examId) {
        String sql = "SELECT COUNT(*) FROM questions WHERE exam_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, examId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting questions for exam: " + examId, e);
        }
        return 0;
    }

    public int countByTeacherId(int teacherId) {
        String sql = "SELECT COUNT(*) FROM questions q JOIN exams e ON q.exam_id = e.id WHERE e.teacher_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, teacherId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting questions by teacher: " + teacherId, e);
        }
        return 0;
    }

    private Question mapQuestion(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setId(rs.getInt("id"));
        q.setExamId(rs.getInt("exam_id"));
        q.setQuestionText(rs.getString("question_text"));
        q.setOptionA(rs.getString("option_a"));
        q.setOptionB(rs.getString("option_b"));
        q.setOptionC(rs.getString("option_c"));
        q.setOptionD(rs.getString("option_d"));
        q.setCorrectOption(rs.getString("correct_option"));
        q.setMarks(rs.getInt("marks"));
        q.setExplanation(rs.getString("explanation"));
        q.setCreatedAt(rs.getTimestamp("created_at"));
        return q;
    }
}

