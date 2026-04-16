package com.skillnest.dao;

import com.skillnest.model.Booking;
import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class BookingDAO {

    public boolean addBooking(Booking booking) {
        String query = "INSERT INTO bookings (post_id, user_id) VALUES (?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, booking.getServiceId()); // keeping model method names same for now, or change to getPostId
            preparedStatement.setInt(2, booking.getUserId());
            
            int result = preparedStatement.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasUserBookedService(int userId, int postId) {
        String query = "SELECT 1 FROM bookings WHERE user_id = ? AND post_id = ?";
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
