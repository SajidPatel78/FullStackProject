package com.skillnest.controller;

import com.skillnest.dao.ConnectionDAO;
import com.skillnest.dao.PostDAO;
import com.skillnest.dao.UserDAO;
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

@WebServlet("/user-profile")
public class UserProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private PostDAO postDAO;
    private ConnectionDAO connectionDAO;

    public void init() {
        userDAO = new UserDAO();
        postDAO = new PostDAO();
        connectionDAO = new ConnectionDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("feed");
            return;
        }

        try {
            int targetUserId = Integer.parseInt(idParam);

            // If it's their own profile, redirect to the normal profile page
            if (targetUserId == currentUser.getId()) {
                response.sendRedirect("profile");
                return;
            }

            User targetUser = userDAO.getUserById(targetUserId);
            if (targetUser == null) {
                response.sendRedirect("feed");
                return;
            }

            // Fetch target user's posts
            List<Post> userPosts = postDAO.getPostsByUserId(currentUser.getId(), targetUserId);

            // Compute stats
            int totalPosts = 0;
            int totalServices = 0;
            int totalLikes = 0;

            for (Post p : userPosts) {
                if ("GIG".equals(p.getPostType())) {
                    totalServices++;
                } else {
                    totalPosts++;
                }
                totalLikes += p.getLikesCount();
            }

            // Check connection status
            boolean isConnected = connectionDAO.isConnected(currentUser.getId(), targetUserId);

            request.setAttribute("targetUser", targetUser);
            request.setAttribute("userPosts", userPosts);
            request.setAttribute("totalPosts", totalPosts);
            request.setAttribute("totalServices", totalServices);
            request.setAttribute("totalLikes", totalLikes);
            request.setAttribute("isConnected", isConnected);

            request.getRequestDispatcher("user-profile.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("feed");
        }
    }
}
