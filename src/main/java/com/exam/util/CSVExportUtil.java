package com.exam.util;

import com.exam.model.Result;

import java.io.PrintWriter;
import java.util.List;

/**
 * Utility for exporting examination results into CSV format.
 */
public class CSVExportUtil {

    /**
     * Writes examination results as CSV with UTF-8 BOM so Excel opens it with proper encoding.
     */
    public static void exportResultsToCSV(PrintWriter writer, List<Result> results, String examTitle) {
        // UTF-8 Byte Order Mark (BOM)
        writer.write('\ufeff');

        writer.println("Result Export: " + escapeCSV(examTitle));
        writer.println("Export Date: " + DateUtil.formatDisplay(new java.util.Date()));
        writer.println();

        // CSV Header
        writer.println("Rank,Roll Number,Student Name,Department,Total Questions,Correct,Incorrect,Unattempted,Total Marks,Obtained Marks,Percentage,Grade,Status,Submitted At");

        if (results == null || results.isEmpty()) {
            writer.println("No records found.");
            return;
        }

        int rank = 1;
        for (Result r : results) {
            StringBuilder sb = new StringBuilder();
            sb.append(rank++).append(",");
            sb.append(escapeCSV(r.getStudentRollNumber())).append(",");
            sb.append(escapeCSV(r.getStudentName())).append(",");
            sb.append(escapeCSV(r.getStudentDepartment())).append(",");
            sb.append(r.getTotalQuestions()).append(",");
            sb.append(r.getCorrectAnswers()).append(",");
            sb.append(r.getIncorrectAnswers()).append(",");
            sb.append(r.getUnattempted()).append(",");
            sb.append(String.format("%.2f", r.getTotalMarks())).append(",");
            sb.append(String.format("%.2f", r.getObtainedMarks())).append(",");
            sb.append(String.format("%.2f%%", r.getPercentage())).append(",");
            sb.append(escapeCSV(r.getGrade())).append(",");
            sb.append(escapeCSV(r.getStatus())).append(",");
            sb.append(escapeCSV(DateUtil.formatDisplay(r.getCreatedAt())));
            writer.println(sb.toString());
        }
    }

    private static String escapeCSV(String value) {
        if (value == null) return "\"\"";
        String clean = value.replace("\"", "\"\"");
        return "\"" + clean + "\"";
    }
}

