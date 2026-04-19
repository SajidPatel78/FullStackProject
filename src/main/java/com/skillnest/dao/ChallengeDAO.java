package com.skillnest.dao;

import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ChallengeDAO {

    private void ensureTables() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS daily_challenges (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "title VARCHAR(200) NOT NULL, " +
                "description TEXT, " +
                "xp_reward INT DEFAULT 50, " +
                "challenge_date DATE NOT NULL, " +
                "category VARCHAR(50))");
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS user_challenges (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "user_id INT NOT NULL, " +
                "challenge_id INT NOT NULL, " +
                "status VARCHAR(20) DEFAULT 'ACCEPTED', " +
                "accepted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "completed_at TIMESTAMP NULL, " +
                "UNIQUE KEY unique_user_challenge (user_id, challenge_id))");
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS user_skills (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "user_id INT NOT NULL, " +
                "skill_name VARCHAR(100) NOT NULL, " +
                "progress INT DEFAULT 0, " +
                "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "UNIQUE KEY unique_user_skill (user_id, skill_name))");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Get today's challenge. Returns null if none exists.
     */
    public Map<String, Object> getTodayChallenge() {
        String query = "SELECT * FROM daily_challenges WHERE challenge_date = CURDATE() ORDER BY id DESC LIMIT 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> challenge = new HashMap<>();
                challenge.put("id", rs.getInt("id"));
                challenge.put("title", rs.getString("title"));
                challenge.put("description", rs.getString("description"));
                challenge.put("xpReward", rs.getInt("xp_reward"));
                challenge.put("category", rs.getString("category"));
                challenge.put("challengeDate", rs.getDate("challenge_date"));
                return challenge;
            }
        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("doesn't exist")) {
                ensureTables();
                seedDefaultChallenges();
                return getTodayChallenge();
            }
        }
        return null;
    }

    /**
     * Check if a user has already accepted today's challenge.
     */
    public boolean hasUserAcceptedChallenge(int userId, int challengeId) {
        String query = "SELECT COUNT(*) FROM user_challenges WHERE user_id = ? AND challenge_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, challengeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            // table doesn't exist
        }
        return false;
    }

    /**
     * Accept a challenge.
     */
    public boolean acceptChallenge(int userId, int challengeId) {
        String query = "INSERT IGNORE INTO user_challenges (user_id, challenge_id, status) VALUES (?, ?, 'ACCEPTED')";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, challengeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("doesn't exist")) {
                ensureTables();
                return acceptChallenge(userId, challengeId);
            }
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Complete a challenge and return the XP reward.
     */
    public int completeChallenge(int userId, int challengeId) {
        String updateQuery = "UPDATE user_challenges SET status = 'COMPLETED', completed_at = NOW() WHERE user_id = ? AND challenge_id = ? AND status = 'ACCEPTED'";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(updateQuery)) {
            ps.setInt(1, userId);
            ps.setInt(2, challengeId);
            int updated = ps.executeUpdate();
            if (updated > 0) {
                // Get XP reward
                PreparedStatement rewardPs = connection.prepareStatement("SELECT xp_reward FROM daily_challenges WHERE id = ?");
                rewardPs.setInt(1, challengeId);
                ResultSet rs = rewardPs.executeQuery();
                if (rs.next()) return rs.getInt("xp_reward");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get user's skill progress.
     */
    public List<Map<String, Object>> getUserSkills(int userId) {
        List<Map<String, Object>> skills = new ArrayList<>();
        String query = "SELECT * FROM user_skills WHERE user_id = ? ORDER BY progress DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> skill = new HashMap<>();
                skill.put("skillName", rs.getString("skill_name"));
                skill.put("progress", rs.getInt("progress"));
                skills.add(skill);
            }
        } catch (SQLException e) {
            // table doesn't exist yet
        }
        return skills;
    }

    /**
     * Update or insert a skill progress for a user.
     */
    public void updateSkillProgress(int userId, String skillName, int progressIncrement) {
        String query = "INSERT INTO user_skills (user_id, skill_name, progress) VALUES (?, ?, ?) " +
                       "ON DUPLICATE KEY UPDATE progress = LEAST(100, progress + ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, skillName);
            ps.setInt(3, Math.min(progressIncrement, 100));
            ps.setInt(4, progressIncrement);
            ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("doesn't exist")) {
                ensureTables();
                updateSkillProgress(userId, skillName, progressIncrement);
            } else {
                e.printStackTrace();
            }
        }
    }

    /**
     * Check if a user has completed a specific challenge.
     */
    public boolean hasUserCompletedChallenge(int userId, int challengeId) {
        String query = "SELECT status FROM user_challenges WHERE user_id = ? AND challenge_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, challengeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return "COMPLETED".equals(rs.getString("status"));
            }
        } catch (SQLException e) {
            // table doesn't exist
        }
        return false;
    }

    /**
     * Get all challenges with the user's status (for the challenges page).
     */
    public List<Map<String, Object>> getAllChallengesWithStatus(int userId) {
        List<Map<String, Object>> challenges = new ArrayList<>();
        String query = "SELECT dc.*, uc.status FROM daily_challenges dc " +
                       "LEFT JOIN user_challenges uc ON dc.id = uc.challenge_id AND uc.user_id = ? " +
                       "ORDER BY dc.challenge_date DESC, dc.id DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> challenge = new HashMap<>();
                challenge.put("id", rs.getInt("id"));
                challenge.put("title", rs.getString("title"));
                challenge.put("description", rs.getString("description"));
                challenge.put("xpReward", rs.getInt("xp_reward"));
                challenge.put("category", rs.getString("category"));
                challenge.put("challengeDate", rs.getDate("challenge_date"));
                String status = rs.getString("status"); // null, ACCEPTED, or COMPLETED
                challenge.put("status", status != null ? status : "AVAILABLE");
                challenges.add(challenge);
            }
        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("doesn't exist")) {
                ensureTables();
                seedDefaultChallenges();
                return getAllChallengesWithStatus(userId);
            }
            e.printStackTrace();
        }
        return challenges;
    }

    /**
     * Seed default daily challenges if the table is empty.
     */
    private void seedDefaultChallenges() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate("INSERT IGNORE INTO daily_challenges (title, description, xp_reward, challenge_date, category) VALUES " +
                "('Build a Todo List App with React', 'Create a simple todo list using React with add, delete, and mark complete.', 100, CURDATE(), 'Coding'), " +
                "('Design a Landing Page in Figma', 'Design a modern SaaS landing page with hero section, features, and CTA.', 80, CURDATE(), 'Design'), " +
                "('Write a Tech Blog Post', 'Write a 500-word blog post explaining a concept you recently learned.', 60, CURDATE(), 'Writing')");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
