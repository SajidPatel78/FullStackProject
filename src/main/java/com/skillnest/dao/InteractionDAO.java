package com.skillnest.dao;

import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class InteractionDAO {

    public boolean addLike(int postId, int userId) {
        String query = "INSERT IGNORE INTO likes (post_id, user_id) VALUES (?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, postId);
            preparedStatement.setInt(2, userId);
            
            return preparedStatement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeLike(int postId, int userId) {
        String query = "DELETE FROM likes WHERE post_id = ? AND user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, postId);
            preparedStatement.setInt(2, userId);
            
            return preparedStatement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addSave(int postId, int userId) {
        String query = "INSERT IGNORE INTO saved_posts (post_id, user_id) VALUES (?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, postId);
            preparedStatement.setInt(2, userId);
            
            return preparedStatement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeSave(int postId, int userId) {
        String query = "DELETE FROM saved_posts WHERE post_id = ? AND user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, postId);
            preparedStatement.setInt(2, userId);
            
            return preparedStatement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
