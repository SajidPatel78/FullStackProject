package com.skillnest.controller;

import com.skillnest.dao.ChallengeDAO;
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
import java.util.Map;

@WebServlet(urlPatterns = {"/challenges", "/challenge"})
public class ChallengeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ChallengeDAO challengeDAO;
    private UserDAO userDAO;

    public void init() {
        challengeDAO = new ChallengeDAO();
        userDAO = new UserDAO();
    }

    /**
     * GET: Display the challenges page with all challenges and user status.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Refresh user data
        User freshUser = userDAO.getUserById(user.getId());
        if (freshUser != null) {
            session.setAttribute("user", freshUser);
            user = freshUser;
        }

        // Today's Challenge
        Map<String, Object> todayChallenge = challengeDAO.getTodayChallenge();
        request.setAttribute("todayChallenge", todayChallenge);
        if (todayChallenge != null) {
            int challengeId = (int) todayChallenge.get("id");
            boolean accepted = challengeDAO.hasUserAcceptedChallenge(user.getId(), challengeId);
            boolean completed = challengeDAO.hasUserCompletedChallenge(user.getId(), challengeId);
            request.setAttribute("challengeAccepted", accepted);
            request.setAttribute("challengeCompleted", completed);
        }

        // All Challenges with user's status
        List<Map<String, Object>> allChallenges = challengeDAO.getAllChallengesWithStatus(user.getId());
        request.setAttribute("allChallenges", allChallenges);

        // User Skills Progress
        List<Map<String, Object>> userSkills = challengeDAO.getUserSkills(user.getId());
        request.setAttribute("userSkills", userSkills);

        request.getRequestDispatcher("challenges.jsp").forward(request, response);
    }

    /**
     * POST: Accept or complete a challenge.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String challengeIdStr = request.getParameter("challengeId");
        String action = request.getParameter("action");
        String returnUrl = request.getParameter("returnUrl");

        if (challengeIdStr != null && !challengeIdStr.isEmpty()) {
            try {
                int challengeId = Integer.parseInt(challengeIdStr);

                if ("accept".equals(action)) {
                    boolean accepted = challengeDAO.acceptChallenge(user.getId(), challengeId);
                    if (accepted) {
                        // Award 25 XP just for accepting
                        userDAO.addXP(user.getId(), 25);
                    }
                } else if ("complete".equals(action)) {
                    int xpReward = challengeDAO.completeChallenge(user.getId(), challengeId);
                    if (xpReward > 0) {
                        userDAO.addXP(user.getId(), xpReward);
                    }
                }

                // Refresh session
                User refreshed = userDAO.getUserById(user.getId());
                if (refreshed != null) session.setAttribute("user", refreshed);

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Redirect back to the page that initiated the action
        if ("challenges".equals(returnUrl)) {
            response.sendRedirect("challenges");
        } else {
            response.sendRedirect("feed");
        }
    }
}
