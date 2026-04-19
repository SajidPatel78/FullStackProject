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

@WebServlet("/post")
public class PostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostDAO postDAO;
    private UserDAO userDAO;
    private ChallengeDAO challengeDAO;

    public void init() {
        postDAO = new PostDAO();
        userDAO = new UserDAO();
        challengeDAO = new ChallengeDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String postType = request.getParameter("postType");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");

        double price = 0.0;
        if ("SERVICE".equals(postType)) {
            try {
                price = Double.parseDouble(priceStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid price format");
                request.getRequestDispatcher("add-post.jsp").forward(request, response);
                return;
            }
        }

        Post post = new Post();
        post.setTitle(title);
        post.setDescription(description);
        post.setPostType(postType);
        post.setCategory(category);
        post.setPrice(price);
        post.setUserId(user.getId());

        if (postDAO.addPost(post)) {
            // Award XP for creating a post
            userDAO.addXP(user.getId(), 50);
            // Update skill progress based on category
            challengeDAO.updateSkillProgress(user.getId(), category, 5);
            // Refresh session user
            User refreshed = userDAO.getUserById(user.getId());
            if (refreshed != null) session.setAttribute("user", refreshed);
            response.sendRedirect("profile?postAdded=true");
        } else {
            request.setAttribute("error", "Failed to add post. Try again.");
            request.getRequestDispatcher("add-post.jsp").forward(request, response);
        }
    }
}
