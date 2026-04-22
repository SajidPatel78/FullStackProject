import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class CheckDB {
    public static void main(String[] args) {
        String URL = "jdbc:mysql://localhost:3306/skillnest";
        String USER = "root";
        String PASSWORD = "root";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Columns in likes:");
            ResultSet rs = stmt.executeQuery("SELECT * FROM likes");
            for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                System.out.println("- " + rs.getMetaData().getColumnName(i));
            }

            System.out.println("Columns in saved_posts:");
            ResultSet rs2 = stmt.executeQuery("SELECT * FROM saved_posts");
            for (int i = 1; i <= rs2.getMetaData().getColumnCount(); i++) {
                System.out.println("- " + rs2.getMetaData().getColumnName(i));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
