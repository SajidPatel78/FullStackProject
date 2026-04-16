package com.skillnest.model;

import java.sql.Timestamp;

public class Post {
    private int id;
    private String title;
    private String description;
    private String postType;
    private String category;
    private double price;
    private int userId;
    private Timestamp createdAt;

    // Display / join fields
    private String username;
    private String userCollege;
    private String userEmail;
    
    // Aggregates
    private double averageRating;
    private boolean bookedByCurrentUser;
    private boolean reviewedByCurrentUser;
    private int likesCount;
    private boolean likedByCurrentUser;
    private boolean savedByCurrentUser;

    public Post() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPostType() { return postType; }
    public void setPostType(String postType) { this.postType = postType; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getUserCollege() { return userCollege; }
    public void setUserCollege(String userCollege) { this.userCollege = userCollege; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public double getAverageRating() { return averageRating; }
    public void setAverageRating(double averageRating) { this.averageRating = averageRating; }

    public boolean isBookedByCurrentUser() { return bookedByCurrentUser; }
    public void setBookedByCurrentUser(boolean bookedByCurrentUser) { this.bookedByCurrentUser = bookedByCurrentUser; }

    public boolean isReviewedByCurrentUser() { return reviewedByCurrentUser; }
    public void setReviewedByCurrentUser(boolean reviewedByCurrentUser) { this.reviewedByCurrentUser = reviewedByCurrentUser; }

    public int getLikesCount() { return likesCount; }
    public void setLikesCount(int likesCount) { this.likesCount = likesCount; }

    public boolean isLikedByCurrentUser() { return likedByCurrentUser; }
    public void setLikedByCurrentUser(boolean likedByCurrentUser) { this.likedByCurrentUser = likedByCurrentUser; }

    public boolean isSavedByCurrentUser() { return savedByCurrentUser; }
    public void setSavedByCurrentUser(boolean savedByCurrentUser) { this.savedByCurrentUser = savedByCurrentUser; }
}
