-- ============================================================
-- SkillNest — Complete Schema
-- Student Freelance Marketplace + Social Feed Platform
-- post_type values: 'GIG' (paid service) | 'NOTES' (study material)
-- ============================================================

CREATE DATABASE IF NOT EXISTS skillnest;
USE skillnest;

-- ─────────────────────────────────────────────────
-- USERS
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    username     VARCHAR(50)  NOT NULL UNIQUE,
    email        VARCHAR(100) NOT NULL UNIQUE,
    password     VARCHAR(255) NOT NULL,
    college_name VARCHAR(100) NOT NULL,
    bio          TEXT,
    xp           INT DEFAULT 0,
    level        INT DEFAULT 1,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────────────
-- POSTS  (GIG = paid gig | NOTES = study material)
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS posts (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    description  TEXT         NOT NULL,
    post_type    VARCHAR(10)  NOT NULL COMMENT 'GIG or NOTES',
    category     VARCHAR(50)  NOT NULL,
    price        DECIMAL(10,2)          COMMENT 'NULL for NOTES',
    delivery_days INT DEFAULT 3         COMMENT 'For GIGs only',
    user_id      INT NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_post_type (post_type),
    INDEX idx_category  (category),
    INDEX idx_user_id   (user_id),
    INDEX idx_created   (created_at DESC)
);

-- ─────────────────────────────────────────────────
-- BOOKINGS  (orders placed on GIGs)
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS bookings (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    post_id    INT NOT NULL,
    user_id    INT NOT NULL,
    status     VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING | COMPLETED | CANCELLED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_booking (post_id, user_id)
);

-- ─────────────────────────────────────────────────
-- REVIEWS  (left after a booking is completed)
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reviews (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    post_id    INT NOT NULL,
    user_id    INT NOT NULL,
    rating     INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment    TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_review (post_id, user_id)
);

-- ─────────────────────────────────────────────────
-- LIKES  (on any post type)
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS likes (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    post_id    INT NOT NULL,
    user_id    INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id)  ON DELETE CASCADE,
    UNIQUE KEY unique_like (post_id, user_id)
);

-- ─────────────────────────────────────────────────
-- SAVED POSTS  (bookmarks)
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS saved_posts (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    post_id    INT NOT NULL,
    user_id    INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_save (post_id, user_id)
);

-- ─────────────────────────────────────────────────
-- MESSAGES  (direct messages between users)
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS messages (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    sender_id   INT  NOT NULL,
    receiver_id INT  NOT NULL,
    content     TEXT NOT NULL,
    is_read     TINYINT(1) DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id)   REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_receiver (receiver_id),
    INDEX idx_convo (sender_id, receiver_id)
);

-- ─────────────────────────────────────────────────
-- CONNECTIONS  (social follows)
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS connections (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    follower_id  INT NOT NULL,
    following_id INT NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (follower_id)  REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_connection (follower_id, following_id)
);

-- ─────────────────────────────────────────────────
-- DAILY CHALLENGES
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS daily_challenges (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    title          VARCHAR(200) NOT NULL,
    description    TEXT,
    xp_reward      INT DEFAULT 50,
    challenge_date DATE NOT NULL,
    category       VARCHAR(50)
);

-- ─────────────────────────────────────────────────
-- USER CHALLENGES  (who accepted / completed what)
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS user_challenges (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT NOT NULL,
    challenge_id INT NOT NULL,
    status       VARCHAR(20) DEFAULT 'ACCEPTED' COMMENT 'ACCEPTED or COMPLETED',
    accepted_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id)      REFERENCES users(id)            ON DELETE CASCADE,
    FOREIGN KEY (challenge_id) REFERENCES daily_challenges(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_challenge (user_id, challenge_id)
);

-- ─────────────────────────────────────────────────
-- USER SKILLS  (progress tracking per skill)
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS user_skills (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT          NOT NULL,
    skill_name VARCHAR(100) NOT NULL,
    progress   INT DEFAULT 0 COMMENT '0-100',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_skill (user_id, skill_name)
);

-- ─────────────────────────────────────────────────
-- REMEMBER ME TOKENS  (persistent login)
-- ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS remember_tokens (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT          NOT NULL,
    token      VARCHAR(128) NOT NULL UNIQUE,
    expires_at TIMESTAMP    NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ─────────────────────────────────────────────────
-- SEED: Daily Challenges
-- ─────────────────────────────────────────────────
INSERT IGNORE INTO daily_challenges (title, description, xp_reward, challenge_date, category) VALUES
('Build a Todo List App with React',  'Create a simple todo list using React with add, delete, and mark complete functionality.',     100, CURDATE(), 'Coding'),
('Design a Landing Page in Figma',    'Design a modern SaaS landing page with hero section, features, and CTA.',                       80,  CURDATE(), 'Design'),
('Write a Tech Blog Post',            'Write a 500-word blog post explaining a concept you recently learned.',                          60,  CURDATE(), 'Writing'),
('Build a REST API with Node.js',     'Create a simple REST API with GET, POST, PUT, DELETE endpoints using Express.js.',              90,  CURDATE(), 'Coding'),
('Create a Responsive Portfolio Site','Build a personal portfolio site with HTML + CSS that works on mobile and desktop.',              70,  CURDATE(), 'Coding');

-- ─────────────────────────────────────────────────
-- MIGRATION helpers (run manually on existing DBs)
-- ─────────────────────────────────────────────────
-- Add missing columns to users:
--   ALTER TABLE users ADD COLUMN bio TEXT AFTER college_name;
--   ALTER TABLE users ADD COLUMN xp INT DEFAULT 0;
--   ALTER TABLE users ADD COLUMN level INT DEFAULT 1;
--
-- Add missing column to posts:
--   ALTER TABLE posts ADD COLUMN delivery_days INT DEFAULT 3 AFTER price;
--
-- Add missing column to messages:
--   ALTER TABLE messages ADD COLUMN is_read TINYINT(1) DEFAULT 0 AFTER content;
--
-- Rename post_type values from SERVICE → GIG (run ONCE):
--   UPDATE posts SET post_type = 'GIG' WHERE post_type = 'SERVICE';
