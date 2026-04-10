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

    public List<Service> getAllServices() {
        List<Service> services = new ArrayList<>();
        String query = "SELECT s.*, u.username FROM services s INNER JOIN users u ON s.user_id = u.id ORDER BY s.created_at DESC";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
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
                
                services.add(service);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    public List<Service> getServicesByUserId(int userId) {
        List<Service> services = new ArrayList<>();
        String query = "SELECT * FROM services WHERE user_id = ? ORDER BY created_at DESC";
        
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
                
                services.add(service);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }
}
