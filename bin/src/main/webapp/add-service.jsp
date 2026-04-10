<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Add Service</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <header>
        <h1>SkillNest</h1>
        <nav>
            <a href="dashboard">Dashboard</a>
            <a href="services">Browse Services</a>
            <a href="logout">Logout</a>
        </nav>
    </header>
    
    <div class="container">
        <div class="card" style="max-width: 600px; margin: 40px auto;">
            <h2>Offer a New Service</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="error-msg"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form action="services" method="post">
                <div class="form-group">
                    <label for="title">Service Title:</label>
                    <input type="text" id="title" name="title" required placeholder="e.g. Math Tutoring, Web Design">
                </div>
                
                <div class="form-group">
                    <label for="description">Description:</label>
                    <textarea id="description" name="description" rows="5" required placeholder="Describe your service in detail..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="price">Price ($):</label>
                    <input type="number" id="price" name="price" step="0.01" min="0" required placeholder="0.00">
                </div>
                
                <button type="submit" class="btn" style="width: 100%;">List Service</button>
            </form>
        </div>
    </div>
</body>
</html>
