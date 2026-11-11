package com.exam.util;

/**
 * Utility for calculating academic grades and performance status.
 */
public class GradeUtil {

    /**
     * Calculates letter grade based on percentage.
     * 90+ : O (Outstanding)
     * 80-89 : A+ (Excellent)
     * 70-79 : A (Very Good)
     * 60-69 : B+ (Good)
     * 50-59 : B (Above Average)
     * 40-49 : C (Pass)
     * <40   : F (Fail)
     */
    public static String calculateGrade(double percentage) {
        if (percentage >= 90.0) return "O";
        if (percentage >= 80.0) return "A+";
        if (percentage >= 70.0) return "A";
        if (percentage >= 60.0) return "B+";
        if (percentage >= 50.0) return "B";
        if (percentage >= 40.0) return "C";
        return "F";
    }

    /**
     * Determines pass/fail status comparing obtained marks with passing marks.
     */
    public static String calculateStatus(double obtainedMarks, double passingMarks) {
        return obtainedMarks >= passingMarks ? "PASS" : "FAIL";
    }

    /**
     * Returns a human-friendly description of the grade.
     */
    public static String getGradeDescription(String grade) {
        if (grade == null) return "Unknown";
        switch (grade.toUpperCase()) {
            case "O": return "Outstanding";
            case "A+": return "Excellent";
            case "A": return "Very Good";
            case "B+": return "Good";
            case "B": return "Above Average";
            case "C": return "Pass";
            case "F": return "Fail";
            default: return grade;
        }
    }
}

