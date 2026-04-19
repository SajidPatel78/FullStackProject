package com.skillnest.controller;

import com.skillnest.dao.RememberMeDAO;
import com.skillnest.dao.UserDAO;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private RememberMeDAO rememberMeDAO;

    public void init() {
        userDAO = new UserDAO();
        rememberMeDAO = new RememberMeDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // If already logged in, skip straight to the feed
        HttpSession existing = request.getSession(false);
        if (existing != null && existing.getAttribute("user") != null) {
            response.sendRedirect("feed");
            return;
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email      = request.getParameter("email");
        String password   = request.getParameter("password");
        boolean rememberMe = "on".equals(request.getParameter("rememberMe"));

        User user = userDAO.loginUser(email, password);

        if (user != null) {
            // ── SESSION ────────────────────────────────────────────────────
            // Server-side session — holds the full User object securely.
            // Default timeout is whatever Tomcat is configured to (usually 30 min).
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);

            if (rememberMe) {
                // Extend session lifetime for "remember me" users
                session.setMaxInactiveInterval(60 * 60 * 24); // 24h while browser open
            }

            // ── COOKIES ────────────────────────────────────────────────────
            // 1. Display cookie (non-sensitive, used by dashboard.jsp for demo)
            javax.servlet.http.Cookie usernameCookie =
                    new javax.servlet.http.Cookie("username", user.getUsername());
            usernameCookie.setMaxAge(rememberMe ? AutoLoginFilter.COOKIE_MAX_AGE : -1); // -1 = session cookie
            usernameCookie.setPath("/");
            response.addCookie(usernameCookie);

            // 2. Remember Me cookie — persists login across browser restarts
            if (rememberMe) {
                String token = rememberMeDAO.createToken(user.getId());
                if (token != null) {
                    AutoLoginFilter.addRememberMeCookie(response, token);
                }
            }

            response.sendRedirect("feed");
        } else {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
