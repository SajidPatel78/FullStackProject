package com.skillnest.controller;

import com.skillnest.dao.ConnectionDAO;
import com.skillnest.dao.UserDAO;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/connect")
public class ConnectionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ConnectionDAO connectionDAO;
    private UserDAO userDAO;

    public void init() {
        connectionDAO = new ConnectionDAO();
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
        String targetIdStr = request.getParameter("targetUserId");
        String action = request.getParameter("action");

        if (targetIdStr != null && !targetIdStr.isEmpty()) {
            try {
                int targetId = Integer.parseInt(targetIdStr);

                if ("connect".equals(action)) {
                    connectionDAO.addConnection(user.getId(), targetId);
                    // Award XP for making a connection
                    userDAO.addXP(user.getId(), 10);
                    // Refresh session user data
                    User refreshed = userDAO.getUserById(user.getId());
                    if (refreshed != null) session.setAttribute("user", refreshed);
                } else if ("disconnect".equals(action)) {
                    connectionDAO.removeConnection(user.getId(), targetId);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("feed");
    }
}
