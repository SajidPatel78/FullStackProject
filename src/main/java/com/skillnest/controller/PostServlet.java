package com.skillnest.controller;

import com.skillnest.dao.PostDAO;
import com.skillnest.dao.UserDAO;
import com.skillnest.dao.ChallengeDAO;
import com.skillnest.model.Post;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/post")
public class PostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostDAO postDAO;
    private UserDAO userDAO;
    private ChallengeDAO challengeDAO;

    public void init() {
        postDAO      = new PostDAO();
        userDAO      = new UserDAO();
        challengeDAO = new ChallengeDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");

        String title        = trim(request.getParameter("title"));
        String description  = trim(request.getParameter("description"));
        String postType     = trim(request.getParameter("postType"));
        String category     = trim(request.getParameter("category"));
        String priceStr     = trim(request.getParameter("price"));
        String deliveryDays = trim(request.getParameter("deliveryDays"));

        // Route errors back to correct form
        String errorPage = "GIG".equals(postType) ? "create-gig.jsp" : "add-post.jsp";

        // ── Validate ──────────────────────────────────────────────
        if (nullOrEmpty(title))       { fwd(request, response, errorPage, "Title is required.");           return; }
        if (nullOrEmpty(description)) { fwd(request, response, errorPage, "Description is required.");     return; }
        if (nullOrEmpty(category))    { fwd(request, response, errorPage, "Please select a category.");    return; }
        if (nullOrEmpty(postType))    { fwd(request, response, errorPage, "Post type is missing.");        return; }
        if (!"GIG".equals(postType) && !"NOTES".equals(postType)) {
            fwd(request, response, errorPage, "Invalid post type: " + postType); return;
        }

        double price = 0.0;
        if ("GIG".equals(postType)) {
            if (nullOrEmpty(priceStr)) { fwd(request, response, "create-gig.jsp", "Price is required for a gig."); return; }
            try {
                price = Double.parseDouble(priceStr);
                if (price <= 0) { fwd(request, response, "create-gig.jsp", "Price must be greater than $0."); return; }
            } catch (NumberFormatException e) {
                fwd(request, response, "create-gig.jsp", "Invalid price — enter a number like 25 or 49.99"); return;
            }
        }

        // ── Build Post ────────────────────────────────────────────
        Post post = new Post();
        post.setTitle(title);
        post.setDescription(description);
        post.setPostType(postType);
        post.setCategory(category);
        post.setPrice(price);
        post.setUserId(user.getId());

        // ── Save ──────────────────────────────────────────────────
        if (postDAO.addPost(post)) {
            userDAO.addXP(user.getId(), 50);
            try { challengeDAO.updateSkillProgress(user.getId(), category, 5); } catch (Exception ignored) {}
            User refreshed = userDAO.getUserById(user.getId());
            if (refreshed != null) session.setAttribute("user", refreshed);

            response.sendRedirect("GIG".equals(postType) ? "gigs" : "feed");
        } else {
            fwd(request, response, errorPage,
                "Couldn't save your post. Please check all fields are correct and try again.");
        }
    }

    private boolean nullOrEmpty(String s) { return s == null || s.isEmpty(); }
    private String trim(String s) { return s != null ? s.trim() : null; }
    private void fwd(HttpServletRequest req, HttpServletResponse res, String page, String error)
            throws ServletException, IOException {
        req.setAttribute("error", error);
        req.getRequestDispatcher(page).forward(req, res);
    }
}
