package com.skillnest.dao;

import com.skillnest.model.User;
import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.UUID;

/**
 * Handles persistent "Remember Me" login tokens.
 * Tokens are stored in the remember_tokens table and linked to a cookie.
 * Tokens expire after 30 days.
 */
public class RememberMeDAO {

    /**
     * Ensure the remember_tokens table exists.
     */
    private void ensureTable() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(
                "CREATE TABLE IF NOT EXISTS remember_tokens (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  user_id INT NOT NULL," +
                "  token VARCHAR(64) NOT NULL UNIQUE," +
                "  expires_at TIMESTAMP NOT NULL," +
                "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                ")"
            );
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Create a new token for a user and return the token string.
     * Expires in 30 days.
     */
    public String createToken(int userId) {
        ensureTable();
        String token = UUID.randomUUID().toString().replace("-", "") + UUID.randomUUID().toString().replace("-", "");
        String query = "INSERT INTO remember_tokens (user_id, token, expires_at) " +
                       "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.executeUpdate();
            return token;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Validate a token and return the associated user_id, or -1 if invalid/expired.
     */
    public int getUserIdByToken(String token) {
        if (token == null || token.isEmpty()) return -1;
        String query = "SELECT user_id FROM remember_tokens " +
                       "WHERE token = ? AND expires_at > NOW()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("doesn't exist")) {
                ensureTable();
            }
        }
        return -1;
    }

    /**
     * Delete all tokens for a user (on logout).
     */
    public void deleteTokensForUser(int userId) {
        String query = "DELETE FROM remember_tokens WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            // table may not exist yet — ignore
        }
    }

    /**
     * Delete a specific token (single-device logout).
     */
    public void deleteToken(String token) {
        if (token == null || token.isEmpty()) return;
        String query = "DELETE FROM remember_tokens WHERE token = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (SQLException e) {
            // ignore
        }
    }

    /**
     * Rotate a token (delete old, issue new). Improves security.
     */
    public String rotateToken(String oldToken, int userId) {
        deleteToken(oldToken);
        return createToken(userId);
    }
}
