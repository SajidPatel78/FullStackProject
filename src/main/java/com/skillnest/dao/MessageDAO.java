package com.skillnest.dao;

import com.skillnest.model.Message;
import com.skillnest.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public boolean sendMessage(Message message) {
        String query = "INSERT INTO messages (sender_id, receiver_id, content) VALUES (?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, message.getSenderId());
            preparedStatement.setInt(2, message.getReceiverId());
            preparedStatement.setString(3, message.getContent());
            
            return preparedStatement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Message> getConversation(int userId1, int userId2) {
        List<Message> messages = new ArrayList<>();
        String query = "SELECT m.*, u1.username as sender_name, u2.username as receiver_name " +
                       "FROM messages m " +
                       "JOIN users u1 ON m.sender_id = u1.id " +
                       "JOIN users u2 ON m.receiver_id = u2.id " +
                       "WHERE (m.sender_id = ? AND m.receiver_id = ?) " +
                       "   OR (m.sender_id = ? AND m.receiver_id = ?) " +
                       "ORDER BY m.created_at ASC";
                       
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, userId1);
            preparedStatement.setInt(2, userId2);
            preparedStatement.setInt(3, userId2);
            preparedStatement.setInt(4, userId1);
            
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                Message msg = new Message();
                msg.setId(rs.getInt("id"));
                msg.setSenderId(rs.getInt("sender_id"));
                msg.setReceiverId(rs.getInt("receiver_id"));
                msg.setContent(rs.getString("content"));
                msg.setCreatedAt(rs.getTimestamp("created_at"));
                msg.setSenderName(rs.getString("sender_name"));
                msg.setReceiverName(rs.getString("receiver_name"));
                messages.add(msg);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }
}
