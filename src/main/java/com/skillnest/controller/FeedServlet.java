package com.skillnest.controller;

import com.skillnest.dao.PostDAO;
import com.skillnest.dao.UserDAO;
import com.skillnest.dao.ChallengeDAO;
import com.skillnest.model.Post;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
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
        
        // Refresh user data from DB (to get latest XP/level)
        User freshUser = userDAO.getUserById(user.getId());
        if (freshUser != null) {
            session.setAttribute("user", freshUser);
            user = freshUser;
        }
        
        // Feed Posts
        String searchQuery = request.getParameter("searchQuery");
        String category = request.getParameter("category");
        String collegeFilter = request.getParameter("collegeFilter");
        
        List<Post> feedPosts = postDAO.getFeed(user.getId(), user.getCollegeName(), null, category, searchQuery, collegeFilter);
        request.setAttribute("posts", feedPosts);
        request.setAttribute("querySearch", searchQuery);
        request.setAttribute("queryCategory", category);
        request.setAttribute("queryCollege", collegeFilter);
        
        // Leaderboard: Top 5 users
        List<User> topUsers = userDAO.getTopUsersByXP(5);
        request.setAttribute("leaderboard", topUsers);
        
        // Suggested users: up to 3
        List<User> suggestedUsers = userDAO.getSuggestedUsers(user.getId(), user.getCollegeName(), 3);
        request.setAttribute("suggestedUsers", suggestedUsers);
        
        // Daily Challenge
        Map<String, Object> todayChallenge = challengeDAO.getTodayChallenge();
        request.setAttribute("todayChallenge", todayChallenge);
        if (todayChallenge != null) {
            int challengeId = (int) todayChallenge.get("id");
            boolean accepted = challengeDAO.hasUserAcceptedChallenge(user.getId(), challengeId);
            boolean completed = challengeDAO.hasUserCompletedChallenge(user.getId(), challengeId);
            request.setAttribute("challengeAccepted", accepted);
            request.setAttribute("challengeCompleted", completed);
        }
        
        // User Skills Progress
        List<Map<String, Object>> userSkills = challengeDAO.getUserSkills(user.getId());
        request.setAttribute("userSkills", userSkills);
        
        // Connection count
        int connectionCount = userDAO.getConnectionCount(user.getId());
        request.setAttribute("connectionCount", connectionCount);
        
        request.getRequestDispatcher("feed.jsp").forward(request, response);
    }
}
