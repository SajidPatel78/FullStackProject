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
import java.util.List;

@WebServlet("/feed")
public class FeedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostDAO postDAO;

    public void init() {
        postDAO = new PostDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        String searchQuery = request.getParameter("searchQuery");
        String category = request.getParameter("category");
        String collegeFilter = request.getParameter("collegeFilter");
        
        List<Post> feedPosts = postDAO.getFeed(user.getId(), user.getCollegeName(), null, category, searchQuery, collegeFilter);
        request.setAttribute("posts", feedPosts);
        request.setAttribute("querySearch", searchQuery);
        request.setAttribute("queryCategory", category);
        request.setAttribute("queryCollege", collegeFilter);
        
        request.getRequestDispatcher("feed.jsp").forward(request, response);
    }
}
