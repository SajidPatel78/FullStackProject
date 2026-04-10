package com.skillnest.model;

import java.sql.Timestamp;

public class Service {
    private int id;
    private String title;
    private String description;
    private double price;
    private int userId;
    private Timestamp createdAt;
    
    // Additional field for display purposes (join query)
    private String username; 

    public Service() {
    }

    public Service(int id, String title, String description, double price, int userId, Timestamp createdAt) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.price = price;
        this.userId = userId;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
