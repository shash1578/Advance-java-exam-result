package com.exam.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

/**
 * Utility for formatting and manipulating dates, exam durations, and timestamps.
 */
public class DateUtil {

    private static final String DEFAULT_FORMAT = "yyyy-MM-dd HH:mm:ss";
    private static final String DISPLAY_FORMAT = "dd MMM yyyy, hh:mm a";
    private static final String HTML_DATETIME_FORMAT = "yyyy-MM-dd'T'HH:mm";

    private static final DateTimeFormatter DISPLAY_DTF = DateTimeFormatter.ofPattern(DISPLAY_FORMAT);
    private static final DateTimeFormatter HTML_DTF = DateTimeFormatter.ofPattern(HTML_DATETIME_FORMAT);

    public static String formatDisplay(Date date) {
        if (date == null) return "-";
        return new SimpleDateFormat(DISPLAY_FORMAT).format(date);
    }

    public static String formatDisplay(Timestamp timestamp) {
        if (timestamp == null) return "-";
        return new SimpleDateFormat(DISPLAY_FORMAT).format(timestamp);
    }

    public static String formatDisplay(LocalDateTime dateTime) {
        if (dateTime == null) return "-";
        return dateTime.format(DISPLAY_DTF);
    }

    public static String formatForInput(Timestamp timestamp) {
        if (timestamp == null) return "";
        return new SimpleDateFormat(HTML_DATETIME_FORMAT).format(timestamp);
    }

    public static Timestamp parseInputTimestamp(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            // Replaces HTML5 datetime-local "T" with space
            String normalized = value.replace("T", " ");
            if (normalized.length() == 16) {
                normalized += ":00";
            }
            return Timestamp.valueOf(normalized);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Calculates the remaining seconds for an attempt given its start time and duration in minutes.
     * Returns 0 if time has expired.
     */
    public static long calculateRemainingSeconds(Timestamp startTime, int durationMinutes) {
        if (startTime == null) return 0;
        long durationMillis = durationMinutes * 60L * 1000L;
        long expiryMillis = startTime.getTime() + durationMillis;
        long currentMillis = System.currentTimeMillis();
        long remainingMillis = expiryMillis - currentMillis;
        return Math.max(0, remainingMillis / 1000L);
    }

    /**
     * Checks if current time is within [startTime, endTime]
     */
    public static boolean isExamActive(Timestamp startTime, Timestamp endTime) {
        if (startTime == null || endTime == null) return false;
        long now = System.currentTimeMillis();
        return now >= startTime.getTime() && now <= endTime.getTime();
    }

    /**
     * Checks if current time is before startTime
     */
    public static boolean isExamUpcoming(Timestamp startTime) {
        if (startTime == null) return false;
        return System.currentTimeMillis() < startTime.getTime();
    }

    /**
     * Checks if current time is after endTime
     */
    public static boolean isExamCompleted(Timestamp endTime) {
        if (endTime == null) return false;
        return System.currentTimeMillis() > endTime.getTime();
    }
}

