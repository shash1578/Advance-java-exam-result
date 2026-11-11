package com.exam.dao;

import com.exam.model.Result;
import com.exam.model.Student;
import com.exam.model.StudentPerformance;
import com.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ResultDAO {

    private static final Logger LOGGER = Logger.getLogger(ResultDAO.class.getName());

    public boolean saveResult(Result result) {
        String sql = "INSERT INTO results (attempt_id, exam_id, student_id, total_questions, correct_answers, " +
                     "incorrect_answers, unattempted, total_marks, obtained_marks, percentage, grade, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE total_questions = VALUES(total_questions), correct_answers = VALUES(correct_answers), " +
                     "incorrect_answers = VALUES(incorrect_answers), unattempted = VALUES(unattempted), total_marks = VALUES(total_marks), " +
                     "obtained_marks = VALUES(obtained_marks), percentage = VALUES(percentage), grade = VALUES(grade), status = VALUES(status)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, result.getAttemptId());
            stmt.setInt(2, result.getExamId());
            stmt.setInt(3, result.getStudentId());
            stmt.setInt(4, result.getTotalQuestions());
            stmt.setInt(5, result.getCorrectAnswers());
            stmt.setInt(6, result.getIncorrectAnswers());
            stmt.setInt(7, result.getUnattempted());
            stmt.setDouble(8, result.getTotalMarks());
            stmt.setDouble(9, result.getObtainedMarks());
            stmt.setDouble(10, result.getPercentage());
            stmt.setString(11, result.getGrade());
            stmt.setString(12, result.getStatus());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        result.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving result", e);
        }
        return false;
    }

    public Result findById(int id) {
        String sql = getBaseResultQuery() + " WHERE r.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResult(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding result by id: " + id, e);
        }
        return null;
    }

    public Result findByAttemptId(int attemptId) {
        String sql = getBaseResultQuery() + " WHERE r.attempt_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, attemptId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResult(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding result by attemptId: " + attemptId, e);
        }
        return null;
    }

    public List<Result> findAll() {
        List<Result> list = new ArrayList<>();
        String sql = getBaseResultQuery() + " ORDER BY r.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapResult(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all results", e);
        }
        return list;
    }

    public List<Result> findByExamId(int examId) {
        List<Result> list = new ArrayList<>();
        String sql = getBaseResultQuery() + " WHERE r.exam_id = ? ORDER BY r.obtained_marks DESC, r.percentage DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, examId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResult(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding results for exam: " + examId, e);
        }
        return list;
    }

    public List<Result> findByStudentId(int studentId) {
        List<Result> list = new ArrayList<>();
        String sql = getBaseResultQuery() + " WHERE r.student_id = ? ORDER BY r.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResult(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding results for student: " + studentId, e);
        }
        return list;
    }

    public StudentPerformance getStudentPerformance(int studentId) {
        StudentDAO studentDAO = new StudentDAO();
        Student student = studentDAO.findById(studentId);
        if (student == null) return null;

        StudentPerformance perf = new StudentPerformance();
        perf.setStudent(student);

        List<Result> results = findByStudentId(studentId);
        perf.setExamResults(results);
        perf.setTotalExamsAttempted(results.size());

        if (results.isEmpty()) {
            perf.setExamsPassed(0);
            perf.setExamsFailed(0);
            perf.setAveragePercentage(0.0);
            perf.setHighestPercentage(0.0);
            perf.setLowestPercentage(0.0);
            return perf;
        }

        int passed = 0;
        int failed = 0;
        double sumPercentage = 0.0;
        double highest = 0.0;
        double lowest = 100.0;

        for (Result r : results) {
            if (r.isPass()) passed++;
            else failed++;

            double pct = r.getPercentage();
            sumPercentage += pct;
            if (pct > highest) highest = pct;
            if (pct < lowest) lowest = pct;
        }

        perf.setExamsPassed(passed);
        perf.setExamsFailed(failed);
        perf.setAveragePercentage(results.isEmpty() ? 0.0 : sumPercentage / results.size());
        perf.setHighestPercentage(highest);
        perf.setLowestPercentage(lowest);

        return perf;
    }

    public double getOverallPassRate() {
        String sql = "SELECT (COUNT(CASE WHEN status = 'PASS' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0)) FROM results";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating overall pass rate", e);
        }
        return 0.0;
    }

    public double getTeacherAverageScore(int teacherId) {
        String sql = "SELECT AVG(r.percentage) FROM results r JOIN exams e ON r.exam_id = e.id WHERE e.teacher_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, teacherId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating teacher average score: " + teacherId, e);
        }
        return 0.0;
    }

    public Map<String, Object> getExamStatistics(int examId) {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT COUNT(*) AS total_students, " +
                     "COALESCE(MAX(obtained_marks), 0) AS highest_marks, " +
                     "COALESCE(MIN(obtained_marks), 0) AS lowest_marks, " +
                     "COALESCE(AVG(obtained_marks), 0) AS average_marks, " +
                     "COALESCE(AVG(percentage), 0) AS average_percentage, " +
                     "COUNT(CASE WHEN status = 'PASS' THEN 1 END) AS passed_count, " +
                     "COUNT(CASE WHEN status = 'FAIL' THEN 1 END) AS failed_count " +
                     "FROM results WHERE exam_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, examId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalStudents", rs.getInt("total_students"));
                    stats.put("highestMarks", rs.getDouble("highest_marks"));
                    stats.put("lowestMarks", rs.getDouble("lowest_marks"));
                    stats.put("averageMarks", rs.getDouble("average_marks"));
                    stats.put("averagePercentage", rs.getDouble("average_percentage"));
                    stats.put("passedCount", rs.getInt("passed_count"));
                    stats.put("failedCount", rs.getInt("failed_count"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating exam statistics for exam: " + examId, e);
        }
        return stats;
    }

    public List<com.exam.model.LeaderboardEntry> getLeaderboardByExam(int examId, int limit) {
        List<com.exam.model.LeaderboardEntry> list = new ArrayList<>();
        String sql = "SELECT r.student_id, r.obtained_marks, r.total_marks, r.percentage, r.grade, " +
                     "u.full_name, st.roll_number, st.department, e.title AS exam_title " +
                     "FROM results r " +
                     "JOIN students st ON r.student_id = st.id " +
                     "JOIN users u ON st.user_id = u.id " +
                     "JOIN exams e ON r.exam_id = e.id " +
                     "WHERE r.exam_id = ? " +
                     "ORDER BY r.obtained_marks DESC, r.percentage DESC " +
                     "LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, examId);
            stmt.setInt(2, limit > 0 ? limit : 50);
            try (ResultSet rs = stmt.executeQuery()) {
                int rank = 1;
                while (rs.next()) {
                    com.exam.model.LeaderboardEntry entry = new com.exam.model.LeaderboardEntry();
                    entry.setRank(rank++);
                    entry.setStudentId(rs.getInt("student_id"));
                    entry.setStudentName(rs.getString("full_name"));
                    entry.setRollNumber(rs.getString("roll_number"));
                    entry.setDepartment(rs.getString("department"));
                    entry.setExamTitle(rs.getString("exam_title"));
                    entry.setScore(rs.getDouble("obtained_marks"));
                    entry.setTotalMarks(rs.getDouble("total_marks"));
                    entry.setPercentage(rs.getDouble("percentage"));
                    entry.setGrade(rs.getString("grade"));
                    list.add(entry);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching exam leaderboard: " + examId, e);
        }
        return list;
    }

    public List<com.exam.model.LeaderboardEntry> getOverallLeaderboard(int limit) {
        List<com.exam.model.LeaderboardEntry> list = new ArrayList<>();
        String sql = "SELECT st.id AS student_id, u.full_name, st.roll_number, st.department, " +
                     "COUNT(r.id) AS exams_attempted, " +
                     "COUNT(CASE WHEN r.status = 'PASS' THEN 1 END) AS exams_passed, " +
                     "COALESCE(AVG(r.percentage), 0) AS avg_percentage, " +
                     "COALESCE(SUM(r.obtained_marks), 0) AS total_score " +
                     "FROM students st " +
                     "JOIN users u ON st.user_id = u.id " +
                     "JOIN results r ON r.student_id = st.id " +
                     "GROUP BY st.id, u.full_name, st.roll_number, st.department " +
                     "ORDER BY avg_percentage DESC, total_score DESC " +
                     "LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit > 0 ? limit : 20);
            try (ResultSet rs = stmt.executeQuery()) {
                int rank = 1;
                while (rs.next()) {
                    com.exam.model.LeaderboardEntry entry = new com.exam.model.LeaderboardEntry();
                    entry.setRank(rank++);
                    entry.setStudentId(rs.getInt("student_id"));
                    entry.setStudentName(rs.getString("full_name"));
                    entry.setRollNumber(rs.getString("roll_number"));
                    entry.setDepartment(rs.getString("department"));
                    entry.setExamsAttempted(rs.getInt("exams_attempted"));
                    entry.setExamsPassed(rs.getInt("exams_passed"));
                    entry.setPercentage(Math.round(rs.getDouble("avg_percentage") * 100.0) / 100.0);
                    entry.setScore(rs.getDouble("total_score"));
                    entry.setGrade(com.exam.util.GradeUtil.calculateGrade(entry.getPercentage()));
                    list.add(entry);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching overall leaderboard", e);
        }
        return list;
    }

    private String getBaseResultQuery() {
        return "SELECT r.*, e.title AS exam_title, e.duration_minutes, e.passing_marks, " +
               "s.subject_name, s.subject_code, " +
               "u.full_name AS student_name, st.roll_number, st.department, " +
               "a.start_time AS attempt_start_time, a.end_time AS attempt_end_time " +
               "FROM results r " +
               "JOIN exams e ON r.exam_id = e.id " +
               "JOIN subjects s ON e.subject_id = s.id " +
               "JOIN students st ON r.student_id = st.id " +
               "JOIN users u ON st.user_id = u.id " +
               "JOIN exam_attempts a ON r.attempt_id = a.id";
    }

    private Result mapResult(ResultSet rs) throws SQLException {
        Result r = new Result();
        r.setId(rs.getInt("id"));
        r.setAttemptId(rs.getInt("attempt_id"));
        r.setExamId(rs.getInt("exam_id"));
        r.setStudentId(rs.getInt("student_id"));
        r.setTotalQuestions(rs.getInt("total_questions"));
        r.setCorrectAnswers(rs.getInt("correct_answers"));
        r.setIncorrectAnswers(rs.getInt("incorrect_answers"));
        r.setUnattempted(rs.getInt("unattempted"));
        r.setTotalMarks(rs.getDouble("total_marks"));
        r.setObtainedMarks(rs.getDouble("obtained_marks"));
        r.setPercentage(rs.getDouble("percentage"));
        r.setGrade(rs.getString("grade"));
        r.setStatus(rs.getString("status"));
        r.setCreatedAt(rs.getTimestamp("created_at"));

        r.setExamTitle(rs.getString("exam_title"));
        r.setDurationMinutes(rs.getInt("duration_minutes"));
        r.setPassingMarks(rs.getInt("passing_marks"));
        r.setSubjectName(rs.getString("subject_name"));
        r.setSubjectCode(rs.getString("subject_code"));
        r.setStudentName(rs.getString("student_name"));
        r.setStudentRollNumber(rs.getString("roll_number"));
        r.setStudentDepartment(rs.getString("department"));
        r.setAttemptStartTime(rs.getTimestamp("attempt_start_time"));
        r.setAttemptEndTime(rs.getTimestamp("attempt_end_time"));
        return r;
    }
}

