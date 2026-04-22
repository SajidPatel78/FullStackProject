import java.util.List;
import com.skillnest.dao.PostDAO;
import com.skillnest.model.Post;

public class CheckDB2 {
    public static void main(String[] args) {
        PostDAO dao = new PostDAO();
        // Assuming user id 4
        List<Post> posts = dao.getPostsByUserId(4, 4);
        System.out.println("User 4 posts count: " + posts.size());
        for (Post p : posts) {
            System.out.println(" - " + p.getTitle());
        }
    }
}
