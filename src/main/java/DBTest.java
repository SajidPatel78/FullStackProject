import com.skillnest.util.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class DBTest {
    public static void main(String[] args) {
        String query = "ALTER TABLE users ADD COLUMN college_name VARCHAR(100) NOT NULL DEFAULT 'Demo College'";
        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement()) {
            
            System.out.println("Executing ALTER TABLE...");
            statement.executeUpdate(query);
            System.out.println("Success! Column added.");
            
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
            e.printStackTrace(System.out);
        }
    }
}
