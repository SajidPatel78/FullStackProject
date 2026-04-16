package com.skillnest.dao;

import com.skillnest.model.Service;
import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public boolean addService(Service service) {
        String query = "INSERT INTO services (title, description, price, user_id) VALUES (?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, service.getTitle());
            preparedStatement.setString(2, service.getDescription());
            preparedStatement.setDouble(3, service.getPrice());
            preparedStatement.setInt(4, service.getUserId());
            
            int result = preparedStatement.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Service> getAllServices(int currentUserId) {
        List<Service> services = new ArrayList<>();
        String query = "SELECT s.*, u.username, " +
                       "IFNULL(ROUND(AVG(r.rating), 1), 0) AS avg_rating, " +
                       "MAX(CASE WHEN b.user_id = ? THEN 1 ELSE 0 END) AS has_booked, " +
                       "MAX(CASE WHEN cur_r.user_id = ? THEN 1 ELSE 0 END) AS has_reviewed " +
                       "FROM services s " +
                       "INNER JOIN users u ON s.user_id = u.id " +
                       "LEFT JOIN reviews r ON s.id = r.service_id " +
                       "LEFT JOIN bookings b ON s.id = b.service_id " +
                       "LEFT JOIN reviews cur_r ON s.id = cur_r.service_id " +
                       "GROUP BY s.id, u.username " +
                       "ORDER BY s.created_at DESC";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, currentUserId);
            preparedStatement.setInt(2, currentUserId);
            
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                Service service = new Service();
                service.setId(rs.getInt("id"));
                service.setTitle(rs.getString("title"));
                service.setDescription(rs.getString("description"));
                service.setPrice(rs.getDouble("price"));
                service.setUserId(rs.getInt("user_id"));
                service.setCreatedAt(rs.getTimestamp("created_at"));
                service.setUsername(rs.getString("username"));
                
                service.setAverageRating(rs.getDouble("avg_rating"));
                service.setBookedByCurrentUser(rs.getInt("has_booked") == 1);
                service.setReviewedByCurrentUser(rs.getInt("has_reviewed") == 1);
                
                services.add(service);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    public List<Service> getServicesByUserId(int userId) {
        List<Service> services = new ArrayList<>();
        String query = "SELECT s.*, IFNULL(ROUND(AVG(r.rating), 1), 0) AS avg_rating " +
                       "FROM services s " +
                       "LEFT JOIN reviews r ON s.id = r.service_id " +
                       "WHERE s.user_id = ? " +
                       "GROUP BY s.id " +
                       "ORDER BY s.created_at DESC";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, userId);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                Service service = new Service();
                service.setId(rs.getInt("id"));
                service.setTitle(rs.getString("title"));
                service.setDescription(rs.getString("description"));
                service.setPrice(rs.getDouble("price"));
                service.setUserId(rs.getInt("user_id"));
                service.setCreatedAt(rs.getTimestamp("created_at"));
                service.setAverageRating(rs.getDouble("avg_rating"));
                
                services.add(service);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }
}
