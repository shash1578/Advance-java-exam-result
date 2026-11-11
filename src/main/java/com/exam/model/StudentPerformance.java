package com.exam.model;

import java.io.Serializable;
import java.util.List;

public class StudentPerformance implements Serializable {
    private static final long serialVersionUID = 1L;

    private Student student;
    private int totalExamsAttempted;
    private int examsPassed;
    private int examsFailed;
    private double averagePercentage;
    private double highestPercentage;
    private double lowestPercentage;
    private List<Result> examResults;

    public StudentPerformance() {}

    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }

    public int getTotalExamsAttempted() { return totalExamsAttempted; }
    public void setTotalExamsAttempted(int totalExamsAttempted) { this.totalExamsAttempted = totalExamsAttempted; }

    public int getExamsPassed() { return examsPassed; }
    public void setExamsPassed(int examsPassed) { this.examsPassed = examsPassed; }

    public int getExamsFailed() { return examsFailed; }
    public void setExamsFailed(int examsFailed) { this.examsFailed = examsFailed; }

    public double getAveragePercentage() { return averagePercentage; }
    public void setAveragePercentage(double averagePercentage) { this.averagePercentage = averagePercentage; }

    public double getHighestPercentage() { return highestPercentage; }
    public void setHighestPercentage(double highestPercentage) { this.highestPercentage = highestPercentage; }

    public double getLowestPercentage() { return lowestPercentage; }
    public void setLowestPercentage(double lowestPercentage) { this.lowestPercentage = lowestPercentage; }

    public List<Result> getExamResults() { return examResults; }
    public void setExamResults(List<Result> examResults) { this.examResults = examResults; }
}

