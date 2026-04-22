package com.skillnest.dao;

import com.skillnest.model.User;
import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Helper to safely extract xp/level (handles missing columns gracefully)
    private void populateUserFromRS(User user, ResultSet rs) throws SQLException {
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setCollegeName(rs.getString("college_name"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            user.setXp(rs.getInt("xp"));
            user.setLevel(rs.getInt("level"));
        } catch (SQLException e) {
            // xp/level columns may not exist yet, default to 0/1
            user.setXp(0);
            user.setLevel(1);
        }
    }

    /**
     * Auto-migrate: adds missing columns to the users table.
     */
    private void autoMigrate() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            try { stmt.executeUpdate("ALTER TABLE users ADD COLUMN college_name VARCHAR(100) NOT NULL DEFAULT 'Demo College'"); } catch (SQLException e) { /* already exists */ }
            try { stmt.executeUpdate("ALTER TABLE users ADD COLUMN xp INT DEFAULT 0"); } catch (SQLException e) { /* already exists */ }
            try { stmt.executeUpdate("ALTER TABLE users ADD COLUMN level INT DEFAULT 1"); } catch (SQLException e) { /* already exists */ }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

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
        String query = "INSERT INTO users (username, email, password, college_name, xp, level) VALUES (?, ?, ?, ?, 0, 1)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getPassword());
            preparedStatement.setString(4, user.getCollegeName());
            
            int result = preparedStatement.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("Unknown column")) {
                autoMigrate();
                // Retry with simpler query
                try (Connection conn2 = DBConnection.getConnection();
                     PreparedStatement ps2 = conn2.prepareStatement("INSERT INTO users (username, email, password, college_name) VALUES (?, ?, ?, ?)")) {
                    ps2.setString(1, user.getUsername());
                    ps2.setString(2, user.getEmail());
                    ps2.setString(3, user.getPassword());
                    ps2.setString(4, user.getCollegeName());
                    return ps2.executeUpdate() > 0;
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
                populateUserFromRS(user, rs);
                return user;
            } else {
                // Demo Mode: Auto-register user if not found
                User newUser = new User();
                String baseUsername = identifier != null && identifier.contains("@") ? identifier.split("@")[0] : identifier;
                long timestamp = System.currentTimeMillis();
                
                if (identifier != null && identifier.contains("@")) {
                    newUser.setEmail(identifier);
                    newUser.setUsername(baseUsername + "_" + timestamp);
                } else {
                    newUser.setEmail(baseUsername + "_" + timestamp + "@demo.com");
                    newUser.setUsername(baseUsername);
                }
                
                newUser.setPassword(password != null && !password.isEmpty() ? password : "password");
                newUser.setCollegeName("Demo College");
                
                if (!registerUser(newUser)) {
                    newUser.setUsername(baseUsername + "_" + timestamp);
                    newUser.setEmail(baseUsername + "_" + timestamp + "@demo.com");
                    registerUser(newUser);
                }
                
                // Fetch the newly created user
                String fallbackQuery = "SELECT * FROM users WHERE email = ?";
                try (PreparedStatement fallbackStmt = connection.prepareStatement(fallbackQuery)) {
                    fallbackStmt.setString(1, newUser.getEmail());
                    ResultSet fallbackRs = fallbackStmt.executeQuery();
                    if (fallbackRs.next()) {
                        User registeredUser = new User();
                        populateUserFromRS(registeredUser, fallbackRs);
                        return registeredUser;
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Add XP to a user and recalculate their level.
     */
    public void addXP(int userId, int xpAmount) {
        String query = "UPDATE users SET xp = xp + ?, level = GREATEST(1, FLOOR((xp + ?) / 500) + 1) WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, xpAmount);
            ps.setInt(2, xpAmount);
            ps.setInt(3, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("Unknown column")) {
                autoMigrate();
                addXP(userId, xpAmount); // retry
            } else {
                e.printStackTrace();
            }
        }
    }

    /**
     * Get the top N users by XP for the leaderboard.
     */
    public List<User> getTopUsersByXP(int limit) {
        List<User> topUsers = new ArrayList<>();
        String query = "SELECT * FROM users ORDER BY xp DESC LIMIT ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                populateUserFromRS(user, rs);
                topUsers.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return topUsers;
    }

    /**
     * Fetch a fresh copy of a user by ID (for refreshing session after XP changes).
     */
    public User getUserById(int userId) {
        String query = "SELECT * FROM users WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                populateUserFromRS(user, rs);
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get suggested users (users from same college, not self, not already connected).
     */
    public List<User> getSuggestedUsers(int userId, String collegeName, int limit) {
        List<User> suggestions = new ArrayList<>();
        String query = "SELECT u.* FROM users u " +
                       "WHERE u.id != ? " +
                       "AND u.id NOT IN (SELECT following_id FROM connections WHERE follower_id = ?) " +
                       "ORDER BY CASE WHEN u.college_name = ? THEN 0 ELSE 1 END, u.xp DESC " +
                       "LIMIT ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setString(3, collegeName);
            ps.setInt(4, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                populateUserFromRS(user, rs);
                suggestions.add(user);
            }
        } catch (SQLException e) {
            // connections table might not exist yet — return empty
            e.printStackTrace();
        }
        return suggestions;
    }

    /**
     * Get the connection count for a user.
     */
    public int getConnectionCount(int userId) {
        String query = "SELECT COUNT(*) FROM connections WHERE follower_id = ? OR following_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            // table might not exist
        }
        return 0;
    }

    /**
     * Get users that this user is connected to.
     */
    public List<User> getConnections(int userId) {
        List<User> connections = new ArrayList<>();
        String query = "SELECT u.* FROM users u " +
                       "INNER JOIN connections c " +
                       "ON (c.follower_id = ? AND c.following_id = u.id) " +
                       "OR (c.following_id = ? AND c.follower_id = u.id) " +
                       "GROUP BY u.id " +
                       "ORDER BY u.xp DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                populateUserFromRS(user, rs);
                connections.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return connections;
    }
}
