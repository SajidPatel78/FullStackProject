package com.skillnest.controller;

import com.skillnest.dao.InteractionDAO;
import com.skillnest.dao.UserDAO;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/interact")
public class InteractionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private InteractionDAO interactionDAO;
    private UserDAO userDAO;

    public void init() {
        interactionDAO = new InteractionDAO();
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        String postIdStr = request.getParameter("postId");
        String returnUrl = request.getParameter("returnUrl");
        
        if (returnUrl == null || returnUrl.isEmpty()) {
            returnUrl = "feed";
        }

        if (postIdStr != null && !postIdStr.isEmpty() && action != null) {
            try {
                int postId = Integer.parseInt(postIdStr);
                
                switch (action) {
                    case "like":
                        interactionDAO.addLike(postId, user.getId());
                        userDAO.addXP(user.getId(), 5);
                        break;
                    case "unlike":
                        interactionDAO.removeLike(postId, user.getId());
                        break;
                    case "save":
                        interactionDAO.addSave(postId, user.getId());
                        userDAO.addXP(user.getId(), 3);
                        break;
                    case "unsave":
                        interactionDAO.removeSave(postId, user.getId());
                        break;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        // Refresh session with latest XP
        User refreshed = userDAO.getUserById(user.getId());
        if (refreshed != null) session.setAttribute("user", refreshed);
        
        response.sendRedirect(returnUrl);
    }
}
