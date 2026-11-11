package com.exam.dao;

import com.exam.model.Student;
import com.exam.model.User;
import com.exam.util.DBConnection;
import com.exam.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StudentDAO {

    private static final Logger LOGGER = Logger.getLogger(StudentDAO.class.getName());
    private final UserDAO userDAO = new UserDAO();

    public boolean createStudent(Student student, String plainPassword) {
        String insertStudentSql = "INSERT INTO students (user_id, roll_number, department, admission_year) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            User user = new User();
            user.setUsername(student.getUsername());
            user.setEmail(student.getEmail());
            user.setFullName(student.getFullName());
            user.setPhone(student.getPhone());
            user.setRole(User.Role.STUDENT);
            user.setActive(student.isActive());
            user.setPasswordHash(PasswordUtil.hashPassword(plainPassword));

            int userId = userDAO.createUser(user, conn);
            student.setUserId(userId);

            try (PreparedStatement stmt = conn.prepareStatement(insertStudentSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, userId);
                stmt.setString(2, student.getRollNumber());
                stmt.setString(3, student.getDepartment());
                stmt.setInt(4, student.getAdmissionYear());
                stmt.executeUpdate();

                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        student.setId(rs.getInt(1));
                    }
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            LOGGER.log(Level.SEVERE, "Error creating student", e);
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public boolean updateStudent(Student student) {
        String updateStudentSql = "UPDATE students SET roll_number = ?, department = ?, admission_year = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Update user details
            User user = userDAO.findById(student.getUserId());
            if (user != null) {
                user.setFullName(student.getFullName());
                user.setEmail(student.getEmail());
                user.setPhone(student.getPhone());
                user.setActive(student.isActive());
                userDAO.updateUser(user);
            }

            try (PreparedStatement stmt = conn.prepareStatement(updateStudentSql)) {
                stmt.setString(1, student.getRollNumber());
                stmt.setString(2, student.getDepartment());
                stmt.setInt(3, student.getAdmissionYear());
                stmt.setInt(4, student.getId());
                stmt.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            LOGGER.log(Level.SEVERE, "Error updating student: " + student.getId(), e);
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public boolean deleteStudent(int studentId) {
        // Deleting the associated user will cascade delete the student record
        Student student = findById(studentId);
        if (student != null) {
            return userDAO.deleteUser(student.getUserId());
        }
        return false;
    }

    public Student findById(int id) {
        String sql = "SELECT s.*, u.username, u.email, u.full_name, u.phone, u.is_active " +
                     "FROM students s JOIN users u ON s.user_id = u.id WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding student by id: " + id, e);
        }
        return null;
    }

    public Student findByUserId(int userId) {
        String sql = "SELECT s.*, u.username, u.email, u.full_name, u.phone, u.is_active " +
                     "FROM students s JOIN users u ON s.user_id = u.id WHERE s.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding student by userId: " + userId, e);
        }
        return null;
    }

    public Student findByRollNumber(String rollNumber) {
        String sql = "SELECT s.*, u.username, u.email, u.full_name, u.phone, u.is_active " +
                     "FROM students s JOIN users u ON s.user_id = u.id WHERE s.roll_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, rollNumber);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding student by rollNumber: " + rollNumber, e);
        }
        return null;
    }

    public List<Student> findAll() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.*, u.username, u.email, u.full_name, u.phone, u.is_active " +
                     "FROM students s JOIN users u ON s.user_id = u.id ORDER BY s.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapStudent(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all students", e);
        }
        return list;
    }

    public List<Student> searchStudents(String query) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.*, u.username, u.email, u.full_name, u.phone, u.is_active " +
                     "FROM students s JOIN users u ON s.user_id = u.id " +
                     "WHERE u.full_name LIKE ? OR s.roll_number LIKE ? OR u.email LIKE ? OR s.department LIKE ? " +
                     "ORDER BY s.roll_number ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String q = "%" + (query == null ? "" : query.trim()) + "%";
            stmt.setString(1, q);
            stmt.setString(2, q);
            stmt.setString(3, q);
            stmt.setString(4, q);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStudent(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching students: " + query, e);
        }
        return list;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM students";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting students", e);
        }
        return 0;
    }

    public boolean existsByRollNumber(String rollNumber, int excludeStudentId) {
        String sql = "SELECT COUNT(*) FROM students WHERE roll_number = ? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, rollNumber);
            stmt.setInt(2, excludeStudentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking rollNumber existence: " + rollNumber, e);
        }
        return false;
    }

    private Student mapStudent(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setUserId(rs.getInt("user_id"));
        s.setRollNumber(rs.getString("roll_number"));
        s.setDepartment(rs.getString("department"));
        s.setAdmissionYear(rs.getInt("admission_year"));

        s.setUsername(rs.getString("username"));
        s.setEmail(rs.getString("email"));
        s.setFullName(rs.getString("full_name"));
        s.setPhone(rs.getString("phone"));
        s.setActive(rs.getBoolean("is_active"));
        return s;
    }
}

