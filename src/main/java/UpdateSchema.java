import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class UpdateSchema {
    public static void main(String[] args) {
        String URL = "jdbc:mysql://localhost:3306/skillnest";
        String USER = "root";
        String PASSWORD = "root";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement()) {
            
            try {
                stmt.executeUpdate("ALTER TABLE posts ADD COLUMN delivery_days INT DEFAULT 3 AFTER price");
                System.out.println("Added delivery_days column to posts");
            } catch (Exception e) {
                System.out.println("delivery_days already exists or error: " + e.getMessage());
            }

            try {
                stmt.executeUpdate("ALTER TABLE messages ADD COLUMN is_read TINYINT(1) DEFAULT 0 AFTER content");
                System.out.println("Added is_read column to messages");
            } catch (Exception e) {
                System.out.println("is_read already exists or error: " + e.getMessage());
            }

            try {
                int rows = stmt.executeUpdate("UPDATE posts SET post_type = 'GIG' WHERE post_type = 'SERVICE'");
                System.out.println("Updated " + rows + " posts to GIG");
            } catch (Exception e) {
                System.out.println("Error updating post_type: " + e.getMessage());
            }

            System.out.println("Schema updates completed successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
