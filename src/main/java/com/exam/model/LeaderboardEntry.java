package com.exam.model;

import java.io.Serializable;

public class LeaderboardEntry implements Serializable {
    private static final long serialVersionUID = 1L;

    private int rank;
    private int studentId;
    private String studentName;
    private String rollNumber;
    private String department;
    private String examTitle;
    private double score;
    private double totalMarks;
    private double percentage;
    private String grade;
    private int examsAttempted;
    private int examsPassed;

    public LeaderboardEntry() {}

    public int getRank() { return rank; }
    public void setRank(int rank) { this.rank = rank; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getExamTitle() { return examTitle; }
    public void setExamTitle(String examTitle) { this.examTitle = examTitle; }

    public double getScore() { return score; }
    public void setScore(double score) { this.score = score; }

    public double getTotalMarks() { return totalMarks; }
    public void setTotalMarks(double totalMarks) { this.totalMarks = totalMarks; }

    public double getPercentage() { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public int getExamsAttempted() { return examsAttempted; }
    public void setExamsAttempted(int examsAttempted) { this.examsAttempted = examsAttempted; }

    public int getExamsPassed() { return examsPassed; }
    public void setExamsPassed(int examsPassed) { this.examsPassed = examsPassed; }
}

