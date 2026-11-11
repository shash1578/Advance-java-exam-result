package com.exam.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Thread-safe Database Connection utility.
 * Loads connection configurations from classpath database.properties.
 */
public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    private static final Properties properties = new Properties();
    private static boolean initialized = false;

    private static String url = "jdbc:mysql://localhost:3306/online_exam_system?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static String username = "root";
    private static String password = "";
    private static String driver = "com.mysql.cj.jdbc.Driver";

    static {
        init();
    }

    private static synchronized void init() {
        if (initialized) {
            return;
        }
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("database.properties")) {
            if (in != null) {
                properties.load(in);
                url = properties.getProperty("db.url", url);
                username = properties.getProperty("db.username", username);
                password = properties.getProperty("db.password", password);
                driver = properties.getProperty("db.driver", driver);
                LOGGER.info("Loaded database configuration from database.properties");
            } else {
                LOGGER.warning("database.properties not found in classpath. Falling back to default settings.");
            }
            Class.forName(driver);
            initialized = true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize database driver or properties", e);
        }
    }

    /**
     * Obtains a new database connection.
     */
    public static Connection getConnection() throws SQLException {
        if (!initialized) {
            init();
        }
        return DriverManager.getConnection(url, username, password);
    }

    /**
     * Safely closes resources without throwing exceptions.
     */
    public static void closeQuietly(AutoCloseable... closeables) {
        if (closeables == null) return;
        for (AutoCloseable c : closeables) {
            if (c != null) {
                try {
                    c.close();
                } catch (Exception ignored) {
                }
            }
        }
    }

    /**
     * Tests database connectivity.
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Database test connection failed: " + e.getMessage());
            return false;
        }
    }
}

