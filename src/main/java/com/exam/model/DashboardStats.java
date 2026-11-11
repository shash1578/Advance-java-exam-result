package com.exam.model;

import java.io.Serializable;
import java.util.List;

public class DashboardStats implements Serializable {
    private static final long serialVersionUID = 1L;

    // Common/Admin stats
    private int totalStudents;
    private int totalTeachers;
    private int totalExams;
    private int totalAttempts;
    private int totalSubjects;
    private double overallPassRate;

    // Teacher specific stats
    private int teacherExamsCount;
    private int teacherQuestionsCount;
    private int teacherAttemptsCount;
    private double teacherAverageScore;

    // Student specific stats
    private int availableExamsCount;
    private int completedExamsCount;
    private int upcomingExamsCount;
    private double studentAveragePercentage;

    public DashboardStats() {}

    public int getTotalStudents() { return totalStudents; }
    public void setTotalStudents(int totalStudents) { this.totalStudents = totalStudents; }

    public int getTotalTeachers() { return totalTeachers; }
    public void setTotalTeachers(int totalTeachers) { this.totalTeachers = totalTeachers; }

    public int getTotalExams() { return totalExams; }
    public void setTotalExams(int totalExams) { this.totalExams = totalExams; }

    public int getTotalAttempts() { return totalAttempts; }
    public void setTotalAttempts(int totalAttempts) { this.totalAttempts = totalAttempts; }

    public int getTotalSubjects() { return totalSubjects; }
    public void setTotalSubjects(int totalSubjects) { this.totalSubjects = totalSubjects; }

    public double getOverallPassRate() { return overallPassRate; }
    public void setOverallPassRate(double overallPassRate) { this.overallPassRate = overallPassRate; }

    public int getTeacherExamsCount() { return teacherExamsCount; }
    public void setTeacherExamsCount(int teacherExamsCount) { this.teacherExamsCount = teacherExamsCount; }

    public int getTeacherQuestionsCount() { return teacherQuestionsCount; }
    public void setTeacherQuestionsCount(int teacherQuestionsCount) { this.teacherQuestionsCount = teacherQuestionsCount; }

    public int getTeacherAttemptsCount() { return teacherAttemptsCount; }
    public void setTeacherAttemptsCount(int teacherAttemptsCount) { this.teacherAttemptsCount = teacherAttemptsCount; }

    public double getTeacherAverageScore() { return teacherAverageScore; }
    public void setTeacherAverageScore(double teacherAverageScore) { this.teacherAverageScore = teacherAverageScore; }

    public int getAvailableExamsCount() { return availableExamsCount; }
    public void setAvailableExamsCount(int availableExamsCount) { this.availableExamsCount = availableExamsCount; }

    public int getCompletedExamsCount() { return completedExamsCount; }
    public void setCompletedExamsCount(int completedExamsCount) { this.completedExamsCount = completedExamsCount; }

    public int getUpcomingExamsCount() { return upcomingExamsCount; }
    public void setUpcomingExamsCount(int upcomingExamsCount) { this.upcomingExamsCount = upcomingExamsCount; }

    public double getStudentAveragePercentage() { return studentAveragePercentage; }
    public void setStudentAveragePercentage(double studentAveragePercentage) { this.studentAveragePercentage = studentAveragePercentage; }
}

