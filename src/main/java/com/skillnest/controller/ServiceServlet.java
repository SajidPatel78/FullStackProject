package com.skillnest.controller;

import com.skillnest.dao.ServiceDAO;
import com.skillnest.model.Service;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/services")
public class ServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ServiceDAO serviceDAO;

    public void init() {
        serviceDAO = new ServiceDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        List<Service> allServices = serviceDAO.getAllServices();
        request.setAttribute("services", allServices);
        request.getRequestDispatcher("view-services.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");

        double price = 0.0;
        try {
            price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid price format");
            request.getRequestDispatcher("add-service.jsp").forward(request, response);
            return;
        }

        Service service = new Service();
        service.setTitle(title);
        service.setDescription(description);
        service.setPrice(price);
        service.setUserId(user.getId());

        if (serviceDAO.addService(service)) {
            response.sendRedirect("dashboard?serviceAdded=true");
        } else {
            request.setAttribute("error", "Failed to add service. Try again.");
            request.getRequestDispatcher("add-service.jsp").forward(request, response);
        }
    }
}
