<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>SkillNest - Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <header>
        <h1>SkillNest</h1>
        <nav>
            <a href="services">Browse Services</a>
            <a href="logout">Logout (${sessionScope.user.username})</a>
        </nav>
    </header>
    
    <div class="container">
        <h2>Dashboard</h2>
        <div class="card">
            <%-- 
                *** Session vs Cookie Context ***
                Here we retrieve the 'username' from the Cookie sent by the browser. Note that we still
                relied on the Session at the top of this JSP to authorize access (which is secure).
                We are just reading the cookie here for display purposes to satisfy the requirement.
            --%>
            <% 
                String cookieUsername = "Guest";
                javax.servlet.http.Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (javax.servlet.http.Cookie cookie : cookies) {
                        if (cookie.getName().equals("username")) {
                            cookieUsername = cookie.getValue();
                            break;
                        }
                    }
                }
            %>
            <h3>Welcome back, <%= cookieUsername %>! (from Cookie)</h3>
            <p>Email: ${sessionScope.user.email}</p>
            <p>Member since: ${sessionScope.user.createdAt}</p>
            <br>
            <a href="add-service.jsp" class="btn">Offer a New Service</a>
        </div>
        
        <h3>Your Offered Services</h3>
        <% if(request.getParameter("serviceAdded") != null) { %>
            <div class="success-msg">Service successfully listed!</div>
        <% } %>
        
        <div class="card">
            <c:choose>
                <c:when test="${empty userServices}">
                    <p>You haven't listed any services yet.</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Description</th>
                                <th>Price</th>
                                <th>Listed On</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="srv" items="${userServices}">
                                <tr>
                                    <td>${srv.title}</td>
                                    <td>${srv.description}</td>
                                    <td>$${srv.price}</td>
                                    <td>${srv.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
