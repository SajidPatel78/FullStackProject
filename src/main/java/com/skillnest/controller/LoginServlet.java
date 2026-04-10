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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.loginUser(username, password);

        if (user != null) {
            // *** Session vs Cookie Explanation ***
            // SESSION: Stored securely on the server side. Recommended for sensitive data like the full User object.
            // Sessions expire automatically after the browser closes or after a period of inactivity (server timeout).
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // COOKIE: Stored on the client's browser (user's computer). Limited to text data (String).
            // Good for non-sensitive data (like simple preferences or basic unhashed usernames for display).
            // Cookies can persist even if the browser closes if a Max-Age is set.
            javax.servlet.http.Cookie usernameCookie = new javax.servlet.http.Cookie("username", user.getUsername());
            usernameCookie.setMaxAge(60 * 60 * 24 * 7); // Persistent cookie: Lasts for 7 days
            response.addCookie(usernameCookie);
            
            response.sendRedirect("dashboard");
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
