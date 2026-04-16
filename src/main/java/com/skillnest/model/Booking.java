package com.skillnest.model;

import java.sql.Timestamp;

public class Booking {
    private int id;
    private int serviceId;
    private int userId;
    private Timestamp createdAt;

    public Booking() {}

    public Booking(int id, int serviceId, int userId, Timestamp createdAt) {
        this.id = id;
        this.serviceId = serviceId;
        this.userId = userId;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
