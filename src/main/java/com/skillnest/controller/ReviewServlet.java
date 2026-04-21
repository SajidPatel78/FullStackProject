package com.skillnest.controller;

import com.skillnest.dao.ReviewDAO;
import com.skillnest.model.Review;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReviewDAO reviewDAO;

    public void init() {
        reviewDAO = new ReviewDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String serviceIdStr = request.getParameter("serviceId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (serviceIdStr != null && ratingStr != null) {
            try {
                int serviceId = Integer.parseInt(serviceIdStr);
                int rating = Integer.parseInt(ratingStr);
                
                if (rating >= 1 && rating <= 5) {
                    // Check if already reviewed
                    if (!reviewDAO.hasUserReviewedService(user.getId(), serviceId)) {
                        Review review = new Review();
                        review.setServiceId(serviceId);
                        review.setUserId(user.getId());
                        review.setRating(rating);
                        review.setComment(comment);
                        
                        reviewDAO.addReview(review);
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        String returnUrl = request.getParameter("returnUrl");
        if (returnUrl != null && !returnUrl.isEmpty()
                && !returnUrl.contains("://")
                && !returnUrl.startsWith("//")) {
            response.sendRedirect(returnUrl);
        } else {
            response.sendRedirect("gigs");
        }
    }
}
