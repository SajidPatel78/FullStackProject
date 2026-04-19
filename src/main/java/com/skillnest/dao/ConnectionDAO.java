package com.skillnest.dao;

import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ConnectionDAO {

    private void ensureTable() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS connections (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "follower_id INT NOT NULL, " +
                "following_id INT NOT NULL, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "UNIQUE KEY unique_connection (follower_id, following_id))");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean addConnection(int followerId, int followingId) {
        String query = "INSERT IGNORE INTO connections (follower_id, following_id) VALUES (?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("doesn't exist")) {
                ensureTable();
                return addConnection(followerId, followingId);
            }
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeConnection(int followerId, int followingId) {
        String query = "DELETE FROM connections WHERE follower_id = ? AND following_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isConnected(int followerId, int followingId) {
        String query = "SELECT COUNT(*) FROM connections WHERE follower_id = ? AND following_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            // table doesn't exist yet
        }
        return false;
    }
}
