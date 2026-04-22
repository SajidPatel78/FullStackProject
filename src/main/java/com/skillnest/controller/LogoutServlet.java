package com.skillnest.controller;

import com.skillnest.dao.RememberMeDAO;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RememberMeDAO rememberMeDAO;

    public void init() {
        rememberMeDAO = new RememberMeDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            // Delete all persistent tokens for this user from the DB
            User user = (User) session.getAttribute("user");
            if (user != null) {
                rememberMeDAO.deleteTokensForUser(user.getId());
            }
            session.invalidate();
        }

        // Clear the remember_me cookie from the browser
        AutoLoginFilter.clearRememberMeCookie(response);

        // The display cookie logic was removed.

        response.sendRedirect("index.jsp");
    }
}
