<%@ page import="com.skillnest.util.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    StringBuilder log = new StringBuilder();
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement()) {
        
        // Add xp and level columns to users
        try { stmt.executeUpdate("ALTER TABLE users ADD COLUMN xp INT DEFAULT 0"); log.append("<i class=\"fa-solid fa-circle-check\"></i> Added 'xp' column\n"); } 
        catch (SQLException e) { log.append("⏭️ 'xp' column already exists\n"); }
        
        try { stmt.executeUpdate("ALTER TABLE users ADD COLUMN level INT DEFAULT 1"); log.append("<i class=\"fa-solid fa-circle-check\"></i> Added 'level' column\n"); } 
        catch (SQLException e) { log.append("⏭️ 'level' column already exists\n"); }
        
        try { stmt.executeUpdate("ALTER TABLE users ADD COLUMN college_name VARCHAR(100) NOT NULL DEFAULT 'Demo College'"); log.append("<i class=\"fa-solid fa-circle-check\"></i> Added 'college_name' column\n"); } 
        catch (SQLException e) { log.append("⏭️ 'college_name' column already exists\n"); }
        
        // Create connections table
        try { stmt.executeUpdate("CREATE TABLE IF NOT EXISTS connections (id INT AUTO_INCREMENT PRIMARY KEY, follower_id INT NOT NULL, following_id INT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, UNIQUE KEY unique_connection (follower_id, following_id))"); 
            log.append("<i class=\"fa-solid fa-circle-check\"></i> Created 'connections' table\n"); } 
        catch (SQLException e) { log.append("❌ connections: " + e.getMessage() + "\n"); }

        // Create daily_challenges table
        try { stmt.executeUpdate("CREATE TABLE IF NOT EXISTS daily_challenges (id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(200) NOT NULL, description TEXT, xp_reward INT DEFAULT 50, challenge_date DATE NOT NULL, category VARCHAR(50))"); 
            log.append("<i class=\"fa-solid fa-circle-check\"></i> Created 'daily_challenges' table\n"); } 
        catch (SQLException e) { log.append("❌ daily_challenges: " + e.getMessage() + "\n"); }

        // Create user_challenges table
        try { stmt.executeUpdate("CREATE TABLE IF NOT EXISTS user_challenges (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, challenge_id INT NOT NULL, status VARCHAR(20) DEFAULT 'ACCEPTED', accepted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, completed_at TIMESTAMP NULL, UNIQUE KEY unique_user_challenge (user_id, challenge_id))"); 
            log.append("<i class=\"fa-solid fa-circle-check\"></i> Created 'user_challenges' table\n"); } 
        catch (SQLException e) { log.append("❌ user_challenges: " + e.getMessage() + "\n"); }

        // Create user_skills table
        try { stmt.executeUpdate("CREATE TABLE IF NOT EXISTS user_skills (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, skill_name VARCHAR(100) NOT NULL, progress INT DEFAULT 0, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, UNIQUE KEY unique_user_skill (user_id, skill_name))"); 
            log.append("<i class=\"fa-solid fa-circle-check\"></i> Created 'user_skills' table\n"); } 
        catch (SQLException e) { log.append("❌ user_skills: " + e.getMessage() + "\n"); }

        // Seed a daily challenge for today
        try { stmt.executeUpdate("INSERT IGNORE INTO daily_challenges (title, description, xp_reward, challenge_date, category) VALUES ('Build a Todo List App with React', 'Create a simple todo list using React with add, delete, and mark complete functionality.', 100, CURDATE(), 'Coding')"); 
            log.append("<i class=\"fa-solid fa-circle-check\"></i> Seeded daily challenge\n"); } 
        catch (SQLException e) { log.append("⏭️ Challenge already seeded\n"); }
        
        // Add delivery_days to posts
        try { stmt.executeUpdate("ALTER TABLE posts ADD COLUMN delivery_days INT DEFAULT 3 AFTER price"); log.append("<i class=\"fa-solid fa-circle-check\"></i> Added 'delivery_days' column to posts\n"); } 
        catch (SQLException e) { log.append("⏭️ 'delivery_days' column already exists\n"); }

        // Add is_read to messages
        try { stmt.executeUpdate("ALTER TABLE messages ADD COLUMN is_read TINYINT(1) DEFAULT 0 AFTER content"); log.append("<i class=\"fa-solid fa-circle-check\"></i> Added 'is_read' column to messages\n"); } 
        catch (SQLException e) { log.append("⏭️ 'is_read' column already exists\n"); }

        // Update post_type SERVICE -> GIG
        try { 
            int rows = stmt.executeUpdate("UPDATE posts SET post_type = 'GIG' WHERE post_type = 'SERVICE'"); 
            log.append("<i class=\"fa-solid fa-circle-check\"></i> Updated ").append(rows).append(" posts from SERVICE to GIG\n"); 
        } 
        catch (SQLException e) { log.append("❌ failed to update post_type: " + e.getMessage() + "\n"); }
        
        // Rename service_id to post_id in reviews
        try { stmt.executeUpdate("ALTER TABLE reviews CHANGE service_id post_id INT NOT NULL"); log.append("<i class=\"fa-solid fa-circle-check\"></i> Renamed 'service_id' to 'post_id' in reviews\n"); } 
        catch (SQLException e) { log.append("⏭️ 'service_id' already renamed in reviews\n"); }
        
        // Rename service_id to post_id in bookings
        try { stmt.executeUpdate("ALTER TABLE bookings CHANGE service_id post_id INT NOT NULL"); log.append("<i class=\"fa-solid fa-circle-check\"></i> Renamed 'service_id' to 'post_id' in bookings\n"); } 
        catch (SQLException e) { log.append("⏭️ 'service_id' already renamed in bookings\n"); }
        
        log.append("\n🎉 Database migration complete!");
        
    } catch (Exception e) {
        log.append("❌ FATAL: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - DB Migration</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=3.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="glass-card auth-card" style="max-width: 600px;">
            <h2><i class="fa-solid fa-wrench"></i> Database Migration</h2>
            <pre style="background: rgba(0,0,0,0.3); padding: 20px; border-radius: 8px; overflow-x: auto; font-size: 0.9rem; line-height: 1.8; color: var(--accent-cyan);"><%= log.toString() %></pre>
            <a href="feed" class="btn-solid" style="display:block; text-align:center; margin-top:20px; text-decoration:none;">Go to Dashboard</a>
        </div>
    </div>
</body>
</html>
