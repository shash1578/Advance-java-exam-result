package com.exam.dao;

import com.exam.model.Teacher;
import com.exam.model.User;
import com.exam.util.DBConnection;
import com.exam.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TeacherDAO {

    private static final Logger LOGGER = Logger.getLogger(TeacherDAO.class.getName());
    private final UserDAO userDAO = new UserDAO();

    public boolean createTeacher(Teacher teacher, String plainPassword) {
        String insertTeacherSql = "INSERT INTO teachers (user_id, employee_id, department, qualification) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            User user = new User();
            user.setUsername(teacher.getUsername());
            user.setEmail(teacher.getEmail());
            user.setFullName(teacher.getFullName());
            user.setPhone(teacher.getPhone());
            user.setRole(User.Role.TEACHER);
            user.setActive(teacher.isActive());
            user.setPasswordHash(PasswordUtil.hashPassword(plainPassword));

            int userId = userDAO.createUser(user, conn);
            teacher.setUserId(userId);

            try (PreparedStatement stmt = conn.prepareStatement(insertTeacherSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, userId);
                stmt.setString(2, teacher.getEmployeeId());
                stmt.setString(3, teacher.getDepartment());
                stmt.setString(4, teacher.getQualification());
                stmt.executeUpdate();

                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        teacher.setId(rs.getInt(1));
                    }
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            LOGGER.log(Level.SEVERE, "Error creating teacher", e);
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public boolean updateTeacher(Teacher teacher) {
        String updateTeacherSql = "UPDATE teachers SET employee_id = ?, department = ?, qualification = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            User user = userDAO.findById(teacher.getUserId());
            if (user != null) {
                user.setFullName(teacher.getFullName());
                user.setEmail(teacher.getEmail());
                user.setPhone(teacher.getPhone());
                user.setActive(teacher.isActive());
                userDAO.updateUser(user);
            }

            try (PreparedStatement stmt = conn.prepareStatement(updateTeacherSql)) {
                stmt.setString(1, teacher.getEmployeeId());
                stmt.setString(2, teacher.getDepartment());
                stmt.setString(3, teacher.getQualification());
                stmt.setInt(4, teacher.getId());
                stmt.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            LOGGER.log(Level.SEVERE, "Error updating teacher: " + teacher.getId(), e);
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public boolean deleteTeacher(int teacherId) {
        Teacher teacher = findById(teacherId);
        if (teacher != null) {
            return userDAO.deleteUser(teacher.getUserId());
        }
        return false;
    }

    public Teacher findById(int id) {
        String sql = "SELECT t.*, u.username, u.email, u.full_name, u.phone, u.is_active " +
                     "FROM teachers t JOIN users u ON t.user_id = u.id WHERE t.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapTeacher(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding teacher by id: " + id, e);
        }
        return null;
    }

    public Teacher findByUserId(int userId) {
        String sql = "SELECT t.*, u.username, u.email, u.full_name, u.phone, u.is_active " +
                     "FROM teachers t JOIN users u ON t.user_id = u.id WHERE t.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapTeacher(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding teacher by userId: " + userId, e);
        }
        return null;
    }

    public List<Teacher> findAll() {
        List<Teacher> list = new ArrayList<>();
        String sql = "SELECT t.*, u.username, u.email, u.full_name, u.phone, u.is_active " +
                     "FROM teachers t JOIN users u ON t.user_id = u.id ORDER BY t.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapTeacher(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all teachers", e);
        }
        return list;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM teachers";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting teachers", e);
        }
        return 0;
    }

    public boolean existsByEmployeeId(String employeeId, int excludeTeacherId) {
        String sql = "SELECT COUNT(*) FROM teachers WHERE employee_id = ? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, employeeId);
            stmt.setInt(2, excludeTeacherId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking employeeId existence: " + employeeId, e);
        }
        return false;
    }

    private Teacher mapTeacher(ResultSet rs) throws SQLException {
        Teacher t = new Teacher();
        t.setId(rs.getInt("id"));
        t.setUserId(rs.getInt("user_id"));
        t.setEmployeeId(rs.getString("employee_id"));
        t.setDepartment(rs.getString("department"));
        t.setQualification(rs.getString("qualification"));

        t.setUsername(rs.getString("username"));
        t.setEmail(rs.getString("email"));
        t.setFullName(rs.getString("full_name"));
        t.setPhone(rs.getString("phone"));
        t.setActive(rs.getBoolean("is_active"));
        return t;
    }
}

