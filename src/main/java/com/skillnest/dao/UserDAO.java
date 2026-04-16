package com.skillnest.dao;

import com.skillnest.model.User;
import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public boolean checkUserExists(String username, String email) {
        String query = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, email);
            
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean registerUser(User user) {
        String query = "INSERT INTO users (username, email, password, college_name) VALUES (?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getPassword());
            preparedStatement.setString(4, user.getCollegeName());
            
            int result = preparedStatement.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            // Auto-migration: if the database schema is outdated and missing college_name
            if (e.getMessage() != null && e.getMessage().contains("Unknown column 'college_name'")) {
                try (Connection conn = DBConnection.getConnection();
                     java.sql.Statement stmt = conn.createStatement()) {
                    stmt.executeUpdate("ALTER TABLE users ADD COLUMN college_name VARCHAR(100) NOT NULL DEFAULT 'Demo College'");
                    // Retry registration after patching the schema
                    return registerUser(user);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            } else {
                e.printStackTrace();
            }
        }
        return false;
    }

    public User loginUser(String identifier, String password) {
        String query = "SELECT * FROM users WHERE email = ? OR username = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, identifier);
            preparedStatement.setString(2, identifier);
            
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setCollegeName(rs.getString("college_name"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                return user;
            } else {
                // Demo Mode: Auto-register user if not found
                User newUser = new User();
                String baseUsername = identifier != null && identifier.contains("@") ? identifier.split("@")[0] : identifier;
                long timestamp = System.currentTimeMillis();
                
                if (identifier != null && identifier.contains("@")) {
                    newUser.setEmail(identifier);
                    newUser.setUsername(baseUsername + "_" + timestamp); // Avoid unique constraint on derived username
                } else {
                    newUser.setEmail(baseUsername + "_" + timestamp + "@demo.com"); // Avoid unique constraint on derived email
                    newUser.setUsername(baseUsername);
                }
                
                newUser.setPassword(password != null && !password.isEmpty() ? password : "password");
                newUser.setCollegeName("Demo College");
                
                // If register fails (e.g. username taken), try fallback with timestamp
                if (!registerUser(newUser)) {
                    newUser.setUsername(baseUsername + "_" + timestamp);
                    newUser.setEmail(baseUsername + "_" + timestamp + "@demo.com");
                    registerUser(newUser);
                }
                
                // Now query again directly by the email we just set
                String fallbackQuery = "SELECT * FROM users WHERE email = ?";
                try (PreparedStatement fallbackStmt = connection.prepareStatement(fallbackQuery)) {
                    fallbackStmt.setString(1, newUser.getEmail());
                    ResultSet fallbackRs = fallbackStmt.executeQuery();
                    if (fallbackRs.next()) {
                        User registeredUser = new User();
                        registeredUser.setId(fallbackRs.getInt("id"));
                        registeredUser.setUsername(fallbackRs.getString("username"));
                        registeredUser.setEmail(fallbackRs.getString("email"));
                        registeredUser.setPassword(fallbackRs.getString("password"));
                        registeredUser.setCollegeName(fallbackRs.getString("college_name"));
                        registeredUser.setCreatedAt(fallbackRs.getTimestamp("created_at"));
                        return registeredUser;
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
