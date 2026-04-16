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

@WebServlet("/services")
public class ServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostDAO postDAO;

    public void init() {
        postDAO = new PostDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        int currentUserId = -1;
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            currentUserId = user.getId();
        }
            
        String category = request.getParameter("category");
        String searchQuery = request.getParameter("searchQuery");
        
        List<Post> allServices = postDAO.getPostsByFilter(currentUserId, "SERVICE", category, searchQuery);
        request.setAttribute("services", allServices);
        request.setAttribute("queryCategory", category);
        request.setAttribute("querySearch", searchQuery);
        
        request.getRequestDispatcher("view-services.jsp").forward(request, response);
    }
}
