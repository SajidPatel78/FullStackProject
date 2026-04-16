package com.skillnest.controller;

import com.skillnest.dao.BookingDAO;
import com.skillnest.model.Booking;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/book")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDAO bookingDAO;

    public void init() {
        bookingDAO = new BookingDAO();
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

        if (serviceIdStr != null && !serviceIdStr.isEmpty()) {
            try {
                int serviceId = Integer.parseInt(serviceIdStr);
                
                // Check if already booked
                if (!bookingDAO.hasUserBookedService(user.getId(), serviceId)) {
                    Booking booking = new Booking();
                    booking.setServiceId(serviceId);
                    booking.setUserId(user.getId());
                    bookingDAO.addBooking(booking);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("services");
    }
}
