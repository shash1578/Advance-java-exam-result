package com.exam.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Question implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int examId;
    private String questionText;
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;
    private String correctOption; // 'A', 'B', 'C', 'D'
    private int marks = 5;
    private String explanation;
    private Timestamp createdAt;

    // Transient student interaction fields (for exam engine)
    private String studentSelectedOption;
    private boolean markedForReview;
    private boolean answered;
    private int questionNumber;

    public Question() {}

    public Question(int id, int examId, String questionText, String optionA, String optionB, String optionC, String optionD, String correctOption, int marks, String explanation) {
        this.id = id;
        this.examId = examId;
        this.questionText = questionText;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.correctOption = correctOption;
        this.marks = marks;
        this.explanation = explanation;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public String getOptionA() { return optionA; }
    public void setOptionA(String optionA) { this.optionA = optionA; }

    public String getOptionB() { return optionB; }
    public void setOptionB(String optionB) { this.optionB = optionB; }

    public String getOptionC() { return optionC; }
    public void setOptionC(String optionC) { this.optionC = optionC; }

    public String getOptionD() { return optionD; }
    public void setOptionD(String optionD) { this.optionD = optionD; }

    public String getCorrectOption() { return correctOption; }
    public void setCorrectOption(String correctOption) { this.correctOption = correctOption; }

    public int getMarks() { return marks; }
    public void setMarks(int marks) { this.marks = marks; }

    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getStudentSelectedOption() { return studentSelectedOption; }
    public void setStudentSelectedOption(String studentSelectedOption) { 
        this.studentSelectedOption = studentSelectedOption; 
        this.answered = studentSelectedOption != null && !studentSelectedOption.trim().isEmpty();
    }

    public boolean isMarkedForReview() { return markedForReview; }
    public void setMarkedForReview(boolean markedForReview) { this.markedForReview = markedForReview; }

    public boolean isAnswered() { return answered; }
    public void setAnswered(boolean answered) { this.answered = answered; }

    public int getQuestionNumber() { return questionNumber; }
    public void setQuestionNumber(int questionNumber) { this.questionNumber = questionNumber; }

    /**
     * Creates a student-safe copy of this question without exposing the correct option or explanation.
     */
    public Question createSanitizedCopy() {
        Question q = new Question();
        q.setId(this.id);
        q.setExamId(this.examId);
        q.setQuestionText(this.questionText);
        q.setOptionA(this.optionA);
        q.setOptionB(this.optionB);
        q.setOptionC(this.optionC);
        q.setOptionD(this.optionD);
        q.setMarks(this.marks);
        q.setQuestionNumber(this.questionNumber);
        q.setStudentSelectedOption(this.studentSelectedOption);
        q.setMarkedForReview(this.markedForReview);
        q.setAnswered(this.answered);
        // deliberately leaving correctOption and explanation as null
        return q;
    }
}

