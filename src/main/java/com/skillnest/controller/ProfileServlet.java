package com.skillnest.controller;

import com.skillnest.dao.PostDAO;
import com.skillnest.model.Post;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import com.skillnest.dao.UserDAO;
import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostDAO postDAO;
    private UserDAO userDAO;

    public void init() {
        postDAO = new PostDAO();
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Fetch posts created by this user
        List<Post> myPosts = postDAO.getPostsByUserId(user.getId(), user.getId());
        
        int totalPosts = 0;
        int totalServices = 0;
        int totalLikes = 0;
        
        for (Post post : myPosts) {
            if ("GIG".equals(post.getPostType())) {
                totalServices++;
            } else {
                totalPosts++;
            }
            totalLikes += post.getLikesCount();
        }
        
        int connectionsCount = userDAO.getConnectionCount(user.getId());
        
        request.setAttribute("myPosts", myPosts);
        request.setAttribute("totalPosts", totalPosts);
        request.setAttribute("totalServices", totalServices);
        request.setAttribute("totalLikes", totalLikes);
        request.setAttribute("connectionsCount", connectionsCount);
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
