package com.skillnest.dao;

import com.skillnest.model.Review;
import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ReviewDAO {

    public boolean addReview(Review review) {
        String query = "INSERT INTO reviews (post_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, review.getServiceId());
            preparedStatement.setInt(2, review.getUserId());
            preparedStatement.setInt(3, review.getRating());
            preparedStatement.setString(4, review.getComment());
            
            int result = preparedStatement.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasUserReviewedService(int userId, int postId) {
        String query = "SELECT 1 FROM reviews WHERE user_id = ? AND post_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, userId);
            preparedStatement.setInt(2, postId);
            
            ResultSet rs = preparedStatement.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
