package com.skillnest.controller;

import com.skillnest.dao.PostDAO;
import com.skillnest.dao.UserDAO;
import com.skillnest.dao.ChallengeDAO;
import com.skillnest.model.Post;
import com.skillnest.model.User;
import com.skillnest.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;

@WebServlet("/feed")
public class FeedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostDAO postDAO;
    private UserDAO userDAO;
    private ChallengeDAO challengeDAO;

    public void init() {
        postDAO = new PostDAO();
        userDAO = new UserDAO();
        challengeDAO = new ChallengeDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Refresh user from DB
        User freshUser = userDAO.getUserById(user.getId());
        if (freshUser != null) { session.setAttribute("user", freshUser); user = freshUser; }

        // ── FEED PARAMS ─────────────────────────────────────────────
        String searchQuery  = request.getParameter("searchQuery");
        String category     = request.getParameter("category");
        String tab          = request.getParameter("tab");       // all / gigs / notes
        String collegeFilter= request.getParameter("collegeFilter");

        // Map tab to post type filter
        String postTypeFilter = null;
        if ("gigs".equals(tab))  postTypeFilter = "GIG";
        if ("notes".equals(tab)) postTypeFilter = "NOTES";

        List<Post> feedPosts = postDAO.getFeed(
                user.getId(), user.getCollegeName(),
                postTypeFilter, category, searchQuery, collegeFilter);
        request.setAttribute("posts", feedPosts);
        request.setAttribute("querySearch",   searchQuery);
        request.setAttribute("queryCategory", category);
        request.setAttribute("queryCollege",  collegeFilter);
        request.setAttribute("activeTab",     tab != null ? tab : "all");

        // ── LEADERBOARD (top 5) ──────────────────────────────────────
        List<User> topUsers = userDAO.getTopUsersByXP(5);
        request.setAttribute("leaderboard", topUsers);

        // ── SUGGESTED USERS (max 3, same college) ───────────────────
        List<User> suggested = userDAO.getSuggestedUsers(user.getId(), user.getCollegeName(), 3);
        request.setAttribute("suggestedUsers", suggested);

        // ── DAILY CHALLENGE ─────────────────────────────────────────
        Map<String, Object> todayChallenge = challengeDAO.getTodayChallenge();
        request.setAttribute("todayChallenge", todayChallenge);
        if (todayChallenge != null) {
            int cid = (int) todayChallenge.get("id");
            request.setAttribute("challengeAccepted", challengeDAO.hasUserAcceptedChallenge(user.getId(), cid));
            request.setAttribute("challengeCompleted", challengeDAO.hasUserCompletedChallenge(user.getId(), cid));
        }

        // ── SKILL PROGRESS ──────────────────────────────────────────
        List<Map<String, Object>> userSkills = challengeDAO.getUserSkills(user.getId());
        request.setAttribute("userSkills", userSkills);

        // ── STATS ────────────────────────────────────────────────────
        int connectionCount = userDAO.getConnectionCount(user.getId());
        request.setAttribute("connectionCount", connectionCount);

        // My active gigs count
        int myGigsCount = countUserGigs(user.getId());
        request.setAttribute("myGigsCount", myGigsCount);

        // Unread / total messages count
        int msgCount = countMessages(user.getId());
        request.setAttribute("msgCount", msgCount);

        // Total bookings received
        int ordersReceived = countOrdersReceived(user.getId());
        request.setAttribute("ordersReceived", ordersReceived);

        request.getRequestDispatcher("feed.jsp").forward(request, response);
    }

    // ── HELPER QUERIES ──────────────────────────────────────────────

    private int countUserGigs(int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "SELECT COUNT(*) FROM posts WHERE user_id = ? AND post_type = 'GIG'")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private int countMessages(int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "SELECT COUNT(*) FROM messages WHERE receiver_id = ?")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { /* messages table may not exist */ }
        return 0;
    }

    private int countOrdersReceived(int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "SELECT COUNT(*) FROM bookings b " +
                "INNER JOIN posts p ON b.post_id = p.id " +
                "WHERE p.user_id = ?")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}
