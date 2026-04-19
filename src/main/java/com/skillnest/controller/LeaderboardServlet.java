package com.skillnest.controller;

import com.skillnest.dao.UserDAO;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/leaderboard")
public class LeaderboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        // Refresh user data
        User freshUser = userDAO.getUserById(currentUser.getId());
        if (freshUser != null) {
            session.setAttribute("user", freshUser);
            currentUser = freshUser;
        }

        // Get top 20 users for leaderboard
        List<User> leaderboard = userDAO.getTopUsersByXP(20);
        request.setAttribute("leaderboard", leaderboard);

        // Calculate current user's rank
        int yourRank = 0;
        for (int i = 0; i < leaderboard.size(); i++) {
            if (leaderboard.get(i).getId() == currentUser.getId()) {
                yourRank = i + 1;
                break;
            }
        }
        request.setAttribute("yourRank", yourRank);

        request.getRequestDispatcher("leaderboard.jsp").forward(request, response);
    }
}
