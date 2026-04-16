package com.skillnest.controller;

import com.skillnest.dao.MessageDAO;
import com.skillnest.model.Message;
import com.skillnest.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/messages")
public class MessageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MessageDAO messageDAO;

    public void init() {
        messageDAO = new MessageDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String toUserIdStr = request.getParameter("toUserId");
        
        if (toUserIdStr != null && !toUserIdStr.isEmpty()) {
            try {
                int toUserId = Integer.parseInt(toUserIdStr);
                List<Message> conversation = messageDAO.getConversation(user.getId(), toUserId);
                request.setAttribute("conversation", conversation);
                request.setAttribute("toUserId", toUserId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        request.getRequestDispatcher("messages.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String toUserIdStr = request.getParameter("toUserId");
        String content = request.getParameter("content");
        
        if (toUserIdStr != null && !toUserIdStr.isEmpty() && content != null && !content.trim().isEmpty()) {
            try {
                int toUserId = Integer.parseInt(toUserIdStr);
                
                Message msg = new Message();
                msg.setSenderId(user.getId());
                msg.setReceiverId(toUserId);
                msg.setContent(content.trim());
                
                messageDAO.sendMessage(msg);
                
                response.sendRedirect("messages?toUserId=" + toUserIdStr);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("feed");
    }
}
