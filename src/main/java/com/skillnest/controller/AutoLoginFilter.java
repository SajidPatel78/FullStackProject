package com.skillnest.controller;

import com.skillnest.dao.RememberMeDAO;
import com.skillnest.dao.UserDAO;
import com.skillnest.model.User;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AutoLoginFilter — runs on every request before pages are served.
 *
 * If the user has no active session but has a valid "remember_me" cookie,
 * this filter automatically restores their session (logs them back in)
 * without requiring them to type their password again.
 *
 * The token is rotated on each auto-login to prevent token theft (rolling tokens).
 */
@WebFilter("/*")
public class AutoLoginFilter implements Filter {

    /** Cookie name stored in the browser */
    public static final String REMEMBER_ME_COOKIE = "remember_me";

    /** Cookie lifetime in seconds: 30 days */
    public static final int COOKIE_MAX_AGE = 60 * 60 * 24 * 30;

    private RememberMeDAO rememberMeDAO;
    private UserDAO userDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        rememberMeDAO = new RememberMeDAO();
        userDAO = new UserDAO();
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        boolean hasSession  = (session != null && session.getAttribute("user") != null);

        // Only try auto-login when there is no active session
        if (!hasSession) {
            String rememberToken = getCookieValue(request, REMEMBER_ME_COOKIE);
            if (rememberToken != null) {
                int userId = rememberMeDAO.getUserIdByToken(rememberToken);
                if (userId > 0) {
                    User user = userDAO.getUserById(userId);
                    if (user != null) {
                        // Restore session
                        HttpSession newSession = request.getSession(true);
                        newSession.setAttribute("user", user);
                        newSession.setMaxInactiveInterval(60 * 60 * 24); // 24h session

                        // Rotate the token for security (rolling token)
                        String newToken = rememberMeDAO.rotateToken(rememberToken, userId);
                        if (newToken != null) {
                            addRememberMeCookie(response, newToken);
                        }
                    } else {
                        // User no longer exists — clear the cookie
                        clearRememberMeCookie(response);
                    }
                } else {
                    // Token invalid or expired — clear the cookie
                    clearRememberMeCookie(response);
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}

    // ─── Helpers ────────────────────────────────────────────────────────────

    /** Find a cookie value by name from the request, or null if not present. */
    public static String getCookieValue(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (name.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    /** Write the remember_me cookie to the response. */
    public static void addRememberMeCookie(HttpServletResponse response, String token) {
        Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, token);
        cookie.setMaxAge(COOKIE_MAX_AGE);
        cookie.setPath("/");
        cookie.setHttpOnly(true);   // Not accessible via JavaScript (XSS protection)
        // cookie.setSecure(true);  // Uncomment when running on HTTPS
        response.addCookie(cookie);
    }

    /** Expire (delete) the remember_me cookie from the browser. */
    public static void clearRememberMeCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, "");
        cookie.setMaxAge(0);        // Instructs browser to delete it
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
    }
}
