package com.skillnest.dao;

import com.skillnest.model.Post;
import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {

    public boolean addPost(Post post) {
        String query = "INSERT INTO posts (title, description, post_type, category, price, user_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, post.getTitle());
            preparedStatement.setString(2, post.getDescription());
            preparedStatement.setString(3, post.getPostType());
            preparedStatement.setString(4, post.getCategory());
            
            if (post.getPostType().equals("SERVICE")) {
                preparedStatement.setDouble(5, post.getPrice());
            } else {
                preparedStatement.setNull(5, Types.DECIMAL);
            }
            preparedStatement.setInt(6, post.getUserId());
            
            int result = preparedStatement.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Post> getFeed(int currentUserId, String userCollege, String postType, String category, String searchQuery, String collegeFilter) {
        List<Post> posts = new ArrayList<>();
        StringBuilder queryBuilder = new StringBuilder();
        queryBuilder.append("SELECT p.*, u.username, u.college_name, u.email as user_email, ")
                    .append("IFNULL(ROUND(AVG(r.rating), 1), 0) AS avg_rating, ")
                    .append("MAX(CASE WHEN b.user_id = ? THEN 1 ELSE 0 END) AS has_booked, ")
                    .append("MAX(CASE WHEN cur_r.user_id = ? THEN 1 ELSE 0 END) AS has_reviewed, ")
                    .append("(SELECT COUNT(*) FROM likes WHERE post_id = p.id) AS likes_count, ")
                    .append("(SELECT COUNT(*) FROM likes WHERE post_id = p.id AND user_id = ?) AS has_liked, ")
                    .append("(SELECT COUNT(*) FROM saved_posts WHERE post_id = p.id AND user_id = ?) AS has_saved ")
                    .append("FROM posts p ")
                    .append("INNER JOIN users u ON p.user_id = u.id ")
                    .append("LEFT JOIN reviews r ON p.id = r.post_id ")
                    .append("LEFT JOIN bookings b ON p.id = b.post_id ")
                    .append("LEFT JOIN reviews cur_r ON p.id = cur_r.post_id ")
                    .append("WHERE 1=1 ");
                    
        List<Object> params = new ArrayList<>();
        params.add(currentUserId);
        params.add(currentUserId);
        params.add(currentUserId);
        params.add(currentUserId);
        
        if (postType != null && !postType.isEmpty()) {
            queryBuilder.append("AND p.post_type = ? ");
            params.add(postType);
        }
        
        if (category != null && !category.isEmpty()) {
            queryBuilder.append("AND p.category = ? ");
            params.add(category);
        }
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            queryBuilder.append("AND p.title LIKE ? ");
            params.add("%" + searchQuery.trim() + "%");
        }
        
        if (collegeFilter != null && !collegeFilter.trim().isEmpty()) {
            queryBuilder.append("AND u.college_name = ? ");
            params.add(collegeFilter.trim());
        }

        queryBuilder.append("GROUP BY p.id, u.username, u.college_name, u.email ")
                    .append("ORDER BY CASE WHEN u.college_name = ? THEN 1 ELSE 0 END DESC, p.created_at DESC");
        params.add(userCollege != null ? userCollege : "");
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(queryBuilder.toString())) {
             
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Integer) {
                    preparedStatement.setInt(i + 1, (Integer) param);
                } else if (param instanceof String) {
                    preparedStatement.setString(i + 1, (String) param);
                }
            }
            
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                posts.add(mapRowToPost(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    public List<Post> getPostsByFilter(int currentUserId, String postType, String category, String searchQuery) {
        List<Post> posts = new ArrayList<>();
        StringBuilder queryBuilder = new StringBuilder();
        queryBuilder.append("SELECT p.*, u.username, u.college_name, u.email as user_email, ")
                    .append("IFNULL(ROUND(AVG(r.rating), 1), 0) AS avg_rating, ")
                    .append("MAX(CASE WHEN b.user_id = ? THEN 1 ELSE 0 END) AS has_booked, ")
                    .append("MAX(CASE WHEN cur_r.user_id = ? THEN 1 ELSE 0 END) AS has_reviewed, ")
                    .append("(SELECT COUNT(*) FROM likes WHERE post_id = p.id) AS likes_count, ")
                    .append("(SELECT COUNT(*) FROM likes WHERE post_id = p.id AND user_id = ?) AS has_liked, ")
                    .append("(SELECT COUNT(*) FROM saved_posts WHERE post_id = p.id AND user_id = ?) AS has_saved ")
                    .append("FROM posts p ")
                    .append("INNER JOIN users u ON p.user_id = u.id ")
                    .append("LEFT JOIN reviews r ON p.id = r.post_id ")
                    .append("LEFT JOIN bookings b ON p.id = b.post_id ")
                    .append("LEFT JOIN reviews cur_r ON p.id = cur_r.post_id ")
                    .append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        params.add(currentUserId);
        params.add(currentUserId);
        params.add(currentUserId);
        params.add(currentUserId);
        
        if (postType != null && !postType.isEmpty()) {
            queryBuilder.append("AND p.post_type = ? ");
            params.add(postType);
        }
        
        if (category != null && !category.isEmpty()) {
            queryBuilder.append("AND p.category = ? ");
            params.add(category);
        }
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            queryBuilder.append("AND p.title LIKE ? ");
            params.add("%" + searchQuery.trim() + "%");
        }
        
        queryBuilder.append("GROUP BY p.id, u.username, u.college_name, u.email ")
                    .append("ORDER BY p.created_at DESC");
                    
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(queryBuilder.toString())) {
             
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Integer) {
                    preparedStatement.setInt(i + 1, (Integer) param);
                } else if (param instanceof String) {
                    preparedStatement.setString(i + 1, (String) param);
                }
            }
            
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                posts.add(mapRowToPost(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    public List<Post> getPostsByUserId(int currentUserId, int targetUserId) {
        List<Post> posts = new ArrayList<>();
        String query = "SELECT p.*, u.username, u.college_name, u.email as user_email, " +
                       "IFNULL(ROUND(AVG(r.rating), 1), 0) AS avg_rating, " +
                       "MAX(CASE WHEN b.user_id = ? THEN 1 ELSE 0 END) AS has_booked, " +
                       "MAX(CASE WHEN cur_r.user_id = ? THEN 1 ELSE 0 END) AS has_reviewed, " +
                       "(SELECT COUNT(*) FROM likes WHERE post_id = p.id) AS likes_count, " +
                       "(SELECT COUNT(*) FROM likes WHERE post_id = p.id AND user_id = ?) AS has_liked, " +
                       "(SELECT COUNT(*) FROM saved_posts WHERE post_id = p.id AND user_id = ?) AS has_saved " +
                       "FROM posts p " +
                       "INNER JOIN users u ON p.user_id = u.id " +
                       "LEFT JOIN reviews r ON p.id = r.post_id " +
                       "LEFT JOIN bookings b ON p.id = b.post_id " +
                       "LEFT JOIN reviews cur_r ON p.id = cur_r.post_id " +
                       "WHERE p.user_id = ? " +
                       "GROUP BY p.id, u.username, u.college_name, u.email " +
                       "ORDER BY p.created_at DESC";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, currentUserId);
            preparedStatement.setInt(2, currentUserId);
            preparedStatement.setInt(3, currentUserId);
            preparedStatement.setInt(4, currentUserId);
            preparedStatement.setInt(5, targetUserId);
            
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                posts.add(mapRowToPost(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }

    private Post mapRowToPost(ResultSet rs) throws SQLException {
        Post post = new Post();
        post.setId(rs.getInt("id"));
        post.setTitle(rs.getString("title"));
        post.setDescription(rs.getString("description"));
        post.setPostType(rs.getString("post_type"));
        post.setCategory(rs.getString("category"));
        if (rs.getObject("price") != null) {
            post.setPrice(rs.getDouble("price"));
        }
        post.setUserId(rs.getInt("user_id"));
        post.setCreatedAt(rs.getTimestamp("created_at"));
        
        post.setUsername(rs.getString("username"));
        post.setUserCollege(rs.getString("college_name"));
        post.setUserEmail(rs.getString("user_email"));
        
        post.setAverageRating(rs.getDouble("avg_rating"));
        post.setBookedByCurrentUser(rs.getInt("has_booked") > 0);
        post.setReviewedByCurrentUser(rs.getInt("has_reviewed") > 0);
        post.setLikesCount(rs.getInt("likes_count"));
        post.setLikedByCurrentUser(rs.getInt("has_liked") > 0);
        post.setSavedByCurrentUser(rs.getInt("has_saved") > 0);
        
        return post;
    }
}
