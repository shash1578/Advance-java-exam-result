package com.exam.model;

import java.io.Serializable;

public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String rollNumber;
    private String department;
    private int admissionYear;

    // Associated User object fields
    private User user;
    private String fullName;
    private String email;
    private String username;
    private String phone;
    private boolean active = true;

    public Student() {}

    public Student(int id, int userId, String rollNumber, String department, int admissionYear) {
        this.id = id;
        this.userId = userId;
        this.rollNumber = rollNumber;
        this.department = department;
        this.admissionYear = admissionYear;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getRollNumber() { return rollNumber; }
    public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public int getAdmissionYear() { return admissionYear; }
    public void setAdmissionYear(int admissionYear) { this.admissionYear = admissionYear; }

    public User getUser() { return user; }
    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.fullName = user.getFullName();
            this.email = user.getEmail();
            this.username = user.getUsername();
            this.phone = user.getPhone();
            this.active = user.isActive();
        }
    }

    public String getFullName() { return fullName != null ? fullName : (user != null ? user.getFullName() : ""); }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email != null ? email : (user != null ? user.getEmail() : ""); }
    public void setEmail(String email) { this.email = email; }

    public String getUsername() { return username != null ? username : (user != null ? user.getUsername() : ""); }
    public void setUsername(String username) { this.username = username; }

    public String getPhone() { return phone != null ? phone : (user != null ? user.getPhone() : ""); }
    public void setPhone(String phone) { this.phone = phone; }

    public boolean isActive() { return user != null ? user.isActive() : active; }
    public void setActive(boolean active) { this.active = active; }
}

