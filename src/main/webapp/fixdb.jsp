<%@ page import="com.skillnest.util.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%
    try (Connection connection = DBConnection.getConnection();
         Statement statement = connection.createStatement()) {
        statement.executeUpdate("ALTER TABLE users ADD COLUMN college_name VARCHAR(100) NOT NULL DEFAULT 'Demo College'");
        out.println("SUCCESS: column added");
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
    }
%>
