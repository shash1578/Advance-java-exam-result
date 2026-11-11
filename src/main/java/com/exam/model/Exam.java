package com.exam.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Exam implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int teacherId;
    private int subjectId;
    private String title;
    private String description;
    private String instructions;
    private int durationMinutes = 30;
    private int totalMarks = 100;
    private int passingMarks = 40;
    private Timestamp startTime;
    private Timestamp endTime;
    private boolean allowMultipleAttempts = false;
    private double negativeMarkingPerQuestion = 0.00;
    private boolean randomizeQuestions = false;
    private boolean published = true;
    private Timestamp createdAt;

    // Associated & Aggregate display fields
    private String teacherName;
    private String subjectName;
    private String subjectCode;
    private int questionCount;
    private int attemptCount;
    private boolean studentAttempted;
    private int studentAttemptId;
    private String studentAttemptStatus;

    public Exam() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTeacherId() { return teacherId; }
    public void setTeacherId(int teacherId) { this.teacherId = teacherId; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }

    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }

    public int getTotalMarks() { return totalMarks; }
    public void setTotalMarks(int totalMarks) { this.totalMarks = totalMarks; }

    public int getPassingMarks() { return passingMarks; }
    public void setPassingMarks(int passingMarks) { this.passingMarks = passingMarks; }

    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }

    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }

    public boolean isAllowMultipleAttempts() { return allowMultipleAttempts; }
    public void setAllowMultipleAttempts(boolean allowMultipleAttempts) { this.allowMultipleAttempts = allowMultipleAttempts; }

    public double getNegativeMarkingPerQuestion() { return negativeMarkingPerQuestion; }
    public void setNegativeMarkingPerQuestion(double negativeMarkingPerQuestion) { this.negativeMarkingPerQuestion = negativeMarkingPerQuestion; }

    public boolean isRandomizeQuestions() { return randomizeQuestions; }
    public void setRandomizeQuestions(boolean randomizeQuestions) { this.randomizeQuestions = randomizeQuestions; }

    public boolean isPublished() { return published; }
    public void setPublished(boolean published) { this.published = published; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public int getQuestionCount() { return questionCount; }
    public void setQuestionCount(int questionCount) { this.questionCount = questionCount; }

    public int getAttemptCount() { return attemptCount; }
    public void setAttemptCount(int attemptCount) { this.attemptCount = attemptCount; }

    public boolean isStudentAttempted() { return studentAttempted; }
    public void setStudentAttempted(boolean studentAttempted) { this.studentAttempted = studentAttempted; }

    public int getStudentAttemptId() { return studentAttemptId; }
    public void setStudentAttemptId(int studentAttemptId) { this.studentAttemptId = studentAttemptId; }

    public String getStudentAttemptStatus() { return studentAttemptStatus; }
    public void setStudentAttemptStatus(String studentAttemptStatus) { this.studentAttemptStatus = studentAttemptStatus; }

    public boolean isActive() {
        if (startTime == null || endTime == null) return false;
        long now = System.currentTimeMillis();
        return now >= startTime.getTime() && now <= endTime.getTime();
    }

    public boolean isUpcoming() {
        if (startTime == null) return false;
        return System.currentTimeMillis() < startTime.getTime();
    }

    public boolean isExpired() {
        if (endTime == null) return false;
        return System.currentTimeMillis() > endTime.getTime();
    }
}

