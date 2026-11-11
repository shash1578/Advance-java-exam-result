package com.exam.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Result implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int attemptId;
    private int examId;
    private int studentId;
    private int totalQuestions;
    private int correctAnswers;
    private int incorrectAnswers;
    private int unattempted;
    private double totalMarks;
    private double obtainedMarks;
    private double percentage;
    private String grade;
    private String status; // PASS or FAIL
    private Timestamp createdAt;

    // Display fields
    private String examTitle;
    private String subjectName;
    private String subjectCode;
    private int durationMinutes;
    private int passingMarks;
    private String studentName;
    private String studentRollNumber;
    private String studentDepartment;
    private Timestamp attemptStartTime;
    private Timestamp attemptEndTime;

    public Result() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAttemptId() { return attemptId; }
    public void setAttemptId(int attemptId) { this.attemptId = attemptId; }

    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getTotalQuestions() { return totalQuestions; }
    public void setTotalQuestions(int totalQuestions) { this.totalQuestions = totalQuestions; }

    public int getCorrectAnswers() { return correctAnswers; }
    public void setCorrectAnswers(int correctAnswers) { this.correctAnswers = correctAnswers; }

    public int getIncorrectAnswers() { return incorrectAnswers; }
    public void setIncorrectAnswers(int incorrectAnswers) { this.incorrectAnswers = incorrectAnswers; }

    public int getUnattempted() { return unattempted; }
    public void setUnattempted(int unattempted) { this.unattempted = unattempted; }

    public double getTotalMarks() { return totalMarks; }
    public void setTotalMarks(double totalMarks) { this.totalMarks = totalMarks; }

    public double getObtainedMarks() { return obtainedMarks; }
    public void setObtainedMarks(double obtainedMarks) { this.obtainedMarks = obtainedMarks; }

    public double getPercentage() { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getExamTitle() { return examTitle; }
    public void setExamTitle(String examTitle) { this.examTitle = examTitle; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }

    public int getPassingMarks() { return passingMarks; }
    public void setPassingMarks(int passingMarks) { this.passingMarks = passingMarks; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentRollNumber() { return studentRollNumber; }
    public void setStudentRollNumber(String studentRollNumber) { this.studentRollNumber = studentRollNumber; }

    public String getStudentDepartment() { return studentDepartment; }
    public void setStudentDepartment(String studentDepartment) { this.studentDepartment = studentDepartment; }

    public Timestamp getAttemptStartTime() { return attemptStartTime; }
    public void setAttemptStartTime(Timestamp attemptStartTime) { this.attemptStartTime = attemptStartTime; }

    public Timestamp getAttemptEndTime() { return attemptEndTime; }
    public void setAttemptEndTime(Timestamp attemptEndTime) { this.attemptEndTime = attemptEndTime; }

    public boolean isPass() {
        return "PASS".equalsIgnoreCase(status);
    }
}

