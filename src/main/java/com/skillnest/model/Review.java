package com.skillnest.model;

import java.sql.Timestamp;

public class Review {
    private int id;
    private int serviceId;
    private int userId;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    // Additional fields for display
    private String username;

    public Review() {}

    public Review(int id, int serviceId, int userId, int rating, String comment, Timestamp createdAt) {
        this.id = id;
        this.serviceId = serviceId;
        this.userId = userId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
}
