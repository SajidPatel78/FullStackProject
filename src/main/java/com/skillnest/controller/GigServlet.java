package com.skillnest.controller;

import com.skillnest.dao.PostDAO;
import com.skillnest.dao.UserDAO;
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
import java.util.Map;

/**
 * GigServlet — mirrors Fiverr's browse + gig-detail flow.
 *
 * GET /gigs          → Browse all gigs (like Fiverr homepage / search results)
 * GET /gig?id=X      → Single gig detail page (like clicking a Fiverr gig card)
 */
@WebServlet(urlPatterns = {"/gigs", "/gig"})
public class GigServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostDAO postDAO;
    private UserDAO userDAO;

    public void init() {
        postDAO = new PostDAO();
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Allow guest browsing — but track current user if logged in
        int currentUserId = 0;
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            currentUserId = user.getId();

            // Refresh session user data
            User fresh = userDAO.getUserById(currentUserId);
            if (fresh != null) session.setAttribute("user", fresh);
        }

        String path = request.getServletPath(); // "/gigs" or "/gig"

        if ("/gig".equals(path)) {
            // ── SINGLE GIG DETAIL ──────────────────────────────────────────
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect("gigs");
                return;
            }
            try {
                int gigId = Integer.parseInt(idStr);
                Post gig = postDAO.getPostById(gigId, currentUserId);

                if (gig == null || !"GIG".equals(gig.getPostType())) {
                    response.sendRedirect("gigs");
                    return;
                }

                // Seller's other gigs
                List<Post> sellerGigs = postDAO.getPostsByUserId(currentUserId, gig.getUserId());
                sellerGigs.removeIf(p -> p.getId() == gigId || !"GIG".equals(p.getPostType()));

                // Reviews for this gig
                List<Map<String, Object>> reviews = postDAO.getReviewsForPost(gigId);

                request.setAttribute("gig",        gig);
                request.setAttribute("sellerGigs", sellerGigs);
                request.setAttribute("reviews",    reviews);
                request.getRequestDispatcher("gig-detail.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect("gigs");
            }

        } else {
            // ── BROWSE ALL GIGS ────────────────────────────────────────────
            String category    = request.getParameter("category");
            String searchQuery = request.getParameter("q");
            String sort        = request.getParameter("sort");

            // Always filter to GIG posts only
            List<Post> gigs = postDAO.getPostsByFilter(currentUserId, "GIG", category, searchQuery);

            // Sort handling (price already done in DB for rating; manual for price)
            if ("price_low".equals(sort)) {
                gigs.sort((a, b) -> Double.compare(a.getPrice(), b.getPrice()));
            } else if ("price_high".equals(sort)) {
                gigs.sort((a, b) -> Double.compare(b.getPrice(), a.getPrice()));
            } else if ("rating".equals(sort)) {
                gigs.sort((a, b) -> Double.compare(b.getAverageRating(), a.getAverageRating()));
            }

            request.setAttribute("gigs",          gigs);
            request.setAttribute("queryCategory", category);
            request.setAttribute("querySearch",   searchQuery);
            request.setAttribute("querySort",     sort);
            request.getRequestDispatcher("gigs.jsp").forward(request, response);
        }
    }
}
